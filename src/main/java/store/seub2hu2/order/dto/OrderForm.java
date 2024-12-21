package store.seub2hu2.order.dto;

import lombok.*;
import store.seub2hu2.order.vo.Order;
import store.seub2hu2.user.vo.User;

import java.util.Date;
import java.util.List;
import java.util.Map;

@ToString
@NoArgsConstructor
@AllArgsConstructor
@Setter
@Getter
public class OrderForm {
    // 유저에 대한 정보
    private User user;

    // 주문 상품에 대한 정보
    private List<Map<String, Integer>> orderItems;
    private List<Integer> sizeNoList; // 사이즈번호(상품번호)
    private List<Integer> stocks; // 수량
    private int orderProdNo; // 주문상품번호
    private int orderProdPrice; // 상품의 가격
    private int orderProdAmount; // 담은 상품 수량
    private int orderUnitPrice; // 개별 상품 총가격

    // 배송지 정보에 대한
    private int addrNo;
    private String addrName; // 받으실 분
    private String addrTel; // 휴대전화 번호
    private String postcode; // 우편번호
    private String addr; // 주소1
    private String addrDetail; // 상세 주소

    // 배송 상태와 배송 업체
    private int deliNo; // 배송 번호
    private String deliName; // 배송 업체
    private String deliMemo; // 배송 메모
    private Order order;
    
    // 주문에 대한 데이터
    private int orderNo; // 주문번호
    private int paymentNo; // 결제 번호
    private Date orderDate; // 주문 날짜
    private String orderStatus; // 주문상태
    private int deliPrice; // 배송비
    private int discountPrice; // 할인금액
    private int realPrice;// 실금액
    private Date orderCreatedDate; // 주문날짜생성
    private Date orderUpdatedDate; // 주문수정날짜 생성

}
