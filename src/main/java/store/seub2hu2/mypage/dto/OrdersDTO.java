package store.seub2hu2.mypage.dto;

import lombok.*;

import java.util.Date;

@NoArgsConstructor
@AllArgsConstructor
@ToString
@Getter
@Setter
public class OrdersDTO {
    private int orderNo;
    private String orderId;
    private Date orderDate;
    private String orderStatus;
    private String receiverName;
    private String deliveryAddress;
    private String receiverPhone;
    private double orderPrice;
    private double delPayment;
    private double disPrice;
    private double realPrice;
    private int payNo;
}
