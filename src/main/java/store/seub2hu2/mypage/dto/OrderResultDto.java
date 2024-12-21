package store.seub2hu2.mypage.dto;

import lombok.*;

import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;
import java.util.UUID;
import java.util.concurrent.atomic.AtomicInteger;

@ToString
@NoArgsConstructor
@AllArgsConstructor
@Setter
@Getter
public class OrderResultDto {
    private static final AtomicInteger sequence = new AtomicInteger(0); // 전역 시퀀스
    private static final int MAX_SEQUENCE = 999; // 시퀀스 최대값 (순환 처리)

    // 결제 관련
    private int payNo; // 결제 번호
    private String payId; // 결제 아이디(tid)
    private String userId; // 유저 아이디
    private Date payDate; // 결제일
    private Date payCancelDate; // 결제 취소일
    private String payMethod; // 결제 방법
    private int payPrice;
    private int payAmount; // 결제건수
    private String payType; // 결제 타입
    private String refund; // 취소 유무

   // 주문 관련
    private int orderNo; // 주문 번호
    private String orderId; // 주문 아이디
    private Date orderDate; // 주문 날짜
    private String orderStatus; //주문 상태
    private int orderPrice; // 상품 가격들
    private double delPayment; // 배송비
    private int disPrice; // 할인 가격
    private int realPrice; // 총 가격

   // 배송 관련
    private int delNo; // 배송 번호
    private String delCom; // 배송업체
    private String delStatus; // 배송 상태
    private String delMemo; // 배송 메모
    private String delPhoneNumber; // 받는 사람 전화번호


    // 배송주소 관련
    private int addrNo; // 배송주소 번호
    private int userNo; // 유저 번호
    private String addrName; // 받는 사람 이름
    private String postcode; // 우편 번호
    private String addr; // 주소1
    private String addrDetail; // 주소 상세
    private String isHome; // 자기 집 유무

    // 주문상품
    private List<OrderResultItemDto> items; // 주문 상품들


    public String getOrderDescription() {
        OrderResultItemDto orderResultItemDto = items.get(0);

        if (items.size() > 1) {
            return orderResultItemDto.getProdName() + " 외 " + (items.size() - 1) + "개";
        } else {
            return orderResultItemDto.getProdName();
        }
    }

    public int getTotalItemAmount() {
        int total = 0;

        for (OrderResultItemDto orderResultItemDto : items) {
            total += orderResultItemDto.getOrderProdAmount();
        }

        return total;
    }

    public String generateOrderId() {
        // 호출 시점의 현재 날짜로 설정
        Date now = new Date();

        // 현재 날짜 부분 생성
        SimpleDateFormat sdf = new SimpleDateFormat("yyyyMMddHH");
        String datePart = sdf.format(now);

        // UUID의 일부를 사용
        String uuidPart = UUID.randomUUID().toString().substring(0, 8); // UUID 앞 8글자만 사용

        // 시퀀스 값 증가
        int currentSequence = sequence.incrementAndGet();
        if (currentSequence > MAX_SEQUENCE) {
            sequence.set(0); // 순환
            currentSequence = sequence.incrementAndGet();
        }

        // 주문 아이디 생성
        return String.format("ORD-%s-%s-%03d", datePart, uuidPart, currentSequence);
    }

}
