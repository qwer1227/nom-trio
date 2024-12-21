package store.seub2hu2.mypage.dto;

import lombok.*;

import java.util.Date;

@NoArgsConstructor
@AllArgsConstructor
@ToString
@Getter
@Setter
public class OrderResponse {
    private int orderNo; // 주문 번호
    private String orderId; // 주문 아이디
    private int sizeNo; // 사이즈 번호
    private Date orderDate; // 주문 날짜
    private String productName; // 상품 이름
    private int productNo; //상품 번호
    private String productImage; // 상품 이미지
    private int productPrice; // 상품 금액
    private int quantity; // 주문 수량
    private String orderStatus; // 주문 상태
    private String deliveryStatus; // 배송 상태
    private int deliveryNo; // 배송 번호
    private int colorNo;

}
