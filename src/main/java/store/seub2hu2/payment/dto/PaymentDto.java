package store.seub2hu2.payment.dto;

import lombok.*;
import store.seub2hu2.delivery.vo.Delivery;
import store.seub2hu2.order.vo.Order;
import store.seub2hu2.order.vo.OrderItem;
import store.seub2hu2.payment.vo.Payment;
import store.seub2hu2.product.vo.Product;
import store.seub2hu2.user.vo.Addr;

import java.util.List;

@AllArgsConstructor
@NoArgsConstructor
@Getter
@Setter
@ToString
public class PaymentDto {
    private String paymentId;       // tid
    private String userId;         // 유저 ID
    private int totalAmount;    // 총 상품가격
    private int quantity;       // 수량
    private String method;      // 결제 방식
    // 상품 파트
    // 주문상품정보
    private List<OrderItem> orderItems; // 주문상품들
    private OrderItem orderItem; // 주문상품
    // 배송지 정보
    private String recipientName; // 받는 사람
    private String postcode; // 우편번호
    private String address; // 주소
    private String addressDetail; // 주소 상세
    private String phoneNumber;

    // 배송 정보
    private String memo; // 배송지 메모
    // 주문정보
    private int orderNo;
    private String orderId; //주문 아이디
    private int totalPrice; // 총 주문 금액(상품가격들)
    private int deliveryPrice; // 배송비
    private int discountPrice; // 할인 금액
    private int finalTotalPrice; // 실제 결제되는 금액

    private int userNo;
    
    // 레슨
    private String title;       // 레슨명
    private int lessonNo;       // 레슨번호
    private String type;       // 레슨 or 상품


    public PaymentDto(Payment payment) {
        this.paymentId = payment.getId();
        this.totalAmount = payment.getAmount();
        this.type = payment.getType();
        this.userId = payment.getUserId();
    }

}
