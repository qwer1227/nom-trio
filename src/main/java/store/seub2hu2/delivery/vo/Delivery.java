package store.seub2hu2.delivery.vo;

import lombok.*;
import store.seub2hu2.order.vo.Order;
import store.seub2hu2.user.vo.Addr;

@ToString
@NoArgsConstructor
@AllArgsConstructor
@Setter
@Getter
public class Delivery {

    private int no; // 배송 번호
    private String company; // 배송 업체
    private String status;
    private String memo; // 배송 메모
    private String deliPhoneNumber;
    private int orderNo; // 주문 번호
    private int addrNo; // 주소 번호
}
