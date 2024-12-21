package store.seub2hu2.order.vo;

import lombok.*;
import store.seub2hu2.payment.vo.Payment;
import store.seub2hu2.user.vo.User;

import java.util.Date;

@ToString
@NoArgsConstructor
@AllArgsConstructor
@Setter
@Getter
public class Order {
    private int no; // 주문번호
    private String orderId; // 주문 아이디
    private Date orderDate; // 주문날짜
    private String status; // 주문 상태
    private int totalPrice; // 총 주문 금액(상품가격들)
    private int deliveryPrice; // 배송비
    private int discountPrice; // 할인 금액
    private int finalTotalPrice; // 실제 결제되는 금액
    private Date orderCreatedDate; // 주문 생성 날짜
    private Date orderUpdatedDate; // 주문 수정 날짜
    private int payNo; // 결제 객체
    private int userNo; // 유저 번호
}
