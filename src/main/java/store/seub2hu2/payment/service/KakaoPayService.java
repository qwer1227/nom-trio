package store.seub2hu2.payment.service;


import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.HttpEntity;
import org.springframework.http.HttpHeaders;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.client.RestTemplate;
import store.seub2hu2.delivery.mapper.DeliveryMapper;
import store.seub2hu2.delivery.vo.Delivery;
import store.seub2hu2.mypage.dto.OrderResultDto;
import store.seub2hu2.mypage.dto.OrderResultItemDto;
import store.seub2hu2.mypage.dto.ResponseDTO;
import store.seub2hu2.mypage.mapper.CartMapper;
import store.seub2hu2.order.exception.*;
import store.seub2hu2.order.mapper.OrderMapper;
import store.seub2hu2.order.vo.Order;
import store.seub2hu2.order.vo.OrderItem;
import store.seub2hu2.payment.dto.PaymentDto;
import store.seub2hu2.payment.dto.ApproveResponse;
import store.seub2hu2.payment.dto.CancelResponse;
import store.seub2hu2.lesson.dto.ReadyResponse;
import store.seub2hu2.product.dto.ProdAmountDto;
import store.seub2hu2.product.dto.ProdDetailDto;
import store.seub2hu2.product.dto.ProdImagesDto;
import store.seub2hu2.product.dto.ProdListDto;
import store.seub2hu2.product.mapper.ProductMapper;
import store.seub2hu2.product.vo.Color;
import store.seub2hu2.product.vo.Product;
import store.seub2hu2.product.vo.Size;
import store.seub2hu2.user.mapper.UserMapper;
import store.seub2hu2.user.vo.Addr;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Slf4j
@Service
public class KakaoPayService {

    @Value("${server.ip}")
    private String serverIp;

    @Autowired
    private ProductMapper productMapper;
    // 주문 맵퍼 인터페이스(주문, 주문상품)
    @Autowired
    private OrderMapper orderMapper;
    // 배송 정보
    @Autowired
    private DeliveryMapper deliveryMapper;
    // 주소지
    @Autowired
    private UserMapper userMapper;

    
    @Value("${kakaopay.secretKey}")
    String secretKey;
    @Autowired
    private CartMapper cartMapper;

    // 카카오페이 결제 승인
    // 사용자가 결제 수단을 선택하고 비밀번호를 입력해 결제 인증을 완료한 뒤,
    // 최종적으로 결제 완료 처리를 하는 단계
    @Transactional
    public ReadyResponse payReady(PaymentDto paymentDto) {
        log.info("Pay ready dto = {}", paymentDto);
        Map<String, String> parameters = new HashMap<>();
        parameters.put("cid", "TC0ONETIME");
        parameters.put("partner_order_id", "1234567890");
        parameters.put("partner_user_id", "seub2hu2");
        parameters.put("quantity", String.valueOf(paymentDto.getQuantity()));

        // 레슨 결제
        if (paymentDto.getType().equals("레슨")) {
            parameters.put("item_name", paymentDto.getTitle());
            parameters.put("item_code", String.valueOf(paymentDto.getLessonNo()));
            parameters.put("total_amount", String.valueOf(paymentDto.getTotalAmount()));

            parameters.put("approval_url", serverIp + "/pay/completed?type=" + paymentDto.getType()
                    + "&lessonNo=" + paymentDto.getLessonNo());
        }

        // 상품 결제
        if (paymentDto.getType().equals("상품")) {
            // 주문정보를 저장한다.
            Order order = new Order();
            order.setTotalPrice(paymentDto.getTotalPrice());
            order.setDeliveryPrice(paymentDto.getDeliveryPrice());
            order.setDiscountPrice(paymentDto.getDiscountPrice());
            order.setFinalTotalPrice(paymentDto.getFinalTotalPrice());
            order.setUserNo(paymentDto.getUserNo());
            order.setOrderId(new OrderResultDto().generateOrderId());

            try {
                orderMapper.insertOrders(order);
            } catch (Exception ex) {
                throw new DatabaseSaveException("주문 정보 저장 실패", ex);
            }

            int orderNo = order.getNo();

            // 주문 상품 정보를 저장한다.
            List<OrderItem> orderItems = paymentDto.getOrderItems();

            // 주문 상품의 이름을 가져오고 싶다.
            int prodNo = orderItems.get(0).getProdNo();
            ProdDetailDto prodDetailDto = productMapper.getProductByNo(prodNo);
            if(prodDetailDto == null) {
                throw new ProductNotFoundException("상품 번호 " + prodNo + "에 대한 정보가 없습니다.");
            }
            String itemName = prodDetailDto.getName();

            if (orderItems.size() > 1) {
                itemName = itemName + " 외 " + (orderItems.size() - 1) + "개" ;
            }

            
            List<Integer> cartNos = new ArrayList<>();
            List<Integer> invalidCartNos = new ArrayList<>(); // 유효하지 않은 값 수집
            for(OrderItem item : orderItems) {
                Size size = productMapper.getSizeAmount(item.getSizeNo());

                // 주문 상품의 재고를 확인한다.
                if(size.getAmount() == 0) {
                    throw new OutOfStockException("상품" + item.getSizeNo() +"는 재고가 없습니다.");
                }

                // 재고가 부족한 경우 StockInsufficientException을 던집니다.
                if (size.getAmount() < item.getStock()) {
                    throw new StockInsufficientException("상품 " + itemName + item.getSizeNo() + "의 재고가 부족합니다. 요청한 수량: "
                            + item.getStock() + ", 남은 재고: " + size.getAmount());
                }

                item.setNo(item.getNo());
                item.setOrderNo(orderNo);
                item.setProdNo(item.getProdNo());
                item.setSizeNo(item.getSizeNo());
                item.setPrice(item.getPrice());
                item.setStock(item.getStock());
                item.setEachTotalPrice(item.getPrice() * item.getStock());

                // 주문 상품에 대한 재고를 감소한다.
                size.setAmount(size.getAmount() - item.getStock());

                // 장바구니에서 상품 삭제
                if(item.getCartNo() <= 0) {
                    invalidCartNos.add(item.getCartNo());
                } else {
                    cartNos.add(item.getCartNo());
                }


                try {
                    productMapper.updateAmount(size);

                } catch (Exception ex) {
                    throw new DatabaseSaveException("주문 상품의 재고 업데이트 실패", ex);
                }
            }

            if(!invalidCartNos.isEmpty()) {
                throw new IllegalArgumentException("유효하지 않은 장바구니 번호" + invalidCartNos);
            }

            // 주문이 된 카트 번호 삭제
            cartMapper.deleteCartItems(cartNos);
            

            try {
                orderMapper.insertOrderItems(orderItems);
            } catch (Exception ex) {
                throw new DatabaseSaveException("주문 상품 정보 저장 실패", ex);
            }


            // 배송지
            Addr addr = new Addr();
            addr.setName(paymentDto.getRecipientName());
            addr.setPostcode(paymentDto.getPostcode());
            addr.setAddress(paymentDto.getAddress());
            addr.setAddressDetail(paymentDto.getAddressDetail());
            addr.setUserNo(paymentDto.getUserNo());

            try {
                userMapper.insertAddress(addr);
            } catch (Exception ex) {
                throw new DatabaseSaveException("배송지 정보 저장 실패", ex);
            }

            int addrNo = addr.getNo();

            // 배송상태
            Delivery delivery = new Delivery();
            delivery.setOrderNo(orderNo);
            delivery.setAddrNo(addrNo);
            delivery.setMemo(paymentDto.getMemo());
            delivery.setDeliPhoneNumber(paymentDto.getPhoneNumber());

            try {
                deliveryMapper.insertDeliveryMemo(delivery);
            } catch (Exception ex) {
                throw new DatabaseSaveException("배송 상태 정보 저장 실패", ex);
            }


            // 결제준비
            // item_name = paymentDto.getItem[0].getProdName()
            // item_code = 주문번호
            // total_amount = 총결재금액
            try {
                parameters.put("item_name", itemName);
                parameters.put("item_code", String.valueOf(orderNo));
                parameters.put("total_amount", String.valueOf(paymentDto.getFinalTotalPrice()));
                parameters.put("approval_url", serverIp + "/pay/completed?type=" + paymentDto.getType()
                        + "&orderNo=" + orderNo);
            } catch (Exception ex) {
                throw new PaymentSystemException("결제 준비 API 호출 중 오류 발생", ex);
            }

        }

        parameters.put("tax_free_amount", "0");

        parameters.put("cancel_url", serverIp + "/pay/cancel");
        parameters.put("fail_url", serverIp + "/pay/fail");


        // HttpEntity : HTTP 요청 또는 응답에 해당하는 Http Header와 Http Body를 포함하는 클래스
        HttpEntity<Map<String, String>> requestEntity = new HttpEntity<>(parameters, this.getHeaders());

        // RestTemplate
        // : Rest 방식 API를 호출할 수 있는 Spring 내장 클래스
        //   REST API 호출 이후 응답을 받을 때까지 기다리는 동기 방식 (json, xml 응답)
        RestTemplate template = new RestTemplate();
        String url = "https://open-api.kakaopay.com/online/v1/payment/ready";
        // RestTemplate의 postForEntity : POST 요청을 보내고 ResponseEntity로 결과를 반환받는 메소드
        ResponseEntity<ReadyResponse> responseEntity = template.postForEntity(url, requestEntity, ReadyResponse.class);
        log.info("결제준비 응답객체: " + responseEntity.getBody());


        return responseEntity.getBody();
    }

    // 카카오페이 결제 승인
    // 사용자가 결제 수단을 선택하고 비밀번호를 입력해 결제 인증을 완료한 뒤,
    // 최종적으로 결제 완료 처리를 하는 단계
    public ApproveResponse payApprove(String tid, String pgToken, int lessonNo) {
        Map<String, String> parameters = new HashMap<>();
        parameters.put("cid", "TC0ONETIME");              // 가맹점 코드(테스트용)
        parameters.put("tid", tid);                       // 결제 고유번호
        parameters.put("partner_order_id", "1234567890"); // 주문번호
        parameters.put("partner_user_id", "seub2hu2");    // 회원 아이디
        parameters.put("pg_token", pgToken);              // 결제승인 요청을 인증하는 토큰
        HttpEntity<Map<String, String>> requestEntity = new HttpEntity<>(parameters, this.getHeaders());

        RestTemplate template = new RestTemplate();
        String url = "https://open-api.kakaopay.com/online/v1/payment/approve";
        ApproveResponse approveResponse = template.postForObject(url, requestEntity, ApproveResponse.class);
        log.info("결제승인 응답객체: " + approveResponse);

        return approveResponse;
    }

    // 카카오페이 결제 취소
    // 사용자가 결제 수단을 선택하고 비밀번호를 입력해 결제 인증을 완료한 뒤,
    // 최종적으로 결제 취소 처리를 하는 단계
    public CancelResponse payCancel(PaymentDto paymentDto, String tid) {

        Map<String, String> parameters = new HashMap<>();
        parameters.put("cid", "TC0ONETIME");
        parameters.put("tid", tid);
        parameters.put("cancel_amount", String.valueOf(paymentDto.getTotalAmount()));
        parameters.put("cancel_tax_free_amount", String.valueOf(0));
        parameters.put("quantity", String.valueOf(paymentDto.getQuantity()));
        log.info("결제 취소 = {}", paymentDto);

        // HttpEntity : HTTP 요청 또는 응답에 해당하는 Http Header와 Http Body를 포함하는 클래스
        HttpEntity<Map<String, String>> requestEntity = new HttpEntity<>(parameters, this.getHeaders());

        // RestTemplate
        // : Rest 방식 API를 호출할 수 있는 Spring 내장 클래스
        //   REST API 호출 이후 응답을 받을 때까지 기다리는 동기 방식 (json, xml 응답)
        RestTemplate template = new RestTemplate();
        String url = "https://open-api.kakaopay.com/online/v1/payment/cancel";
        // RestTemplate의 postForEntity : POST 요청을 보내고 ResponseEntity로 결과를 반환받는 메소드
        CancelResponse cancelResponse = template.postForObject(url, requestEntity, CancelResponse.class);
        log.info("결제취소 응답객체: " + cancelResponse);

        return cancelResponse;
    }

    // 카카오페이 측에 요청 시 헤더부에 필요한 값
    private HttpHeaders getHeaders() {
        HttpHeaders headers = new HttpHeaders();
        headers.set("Authorization", "SECRET_KEY " + secretKey);
        headers.set("Content-type", "application/json");

        return headers;
    }
}