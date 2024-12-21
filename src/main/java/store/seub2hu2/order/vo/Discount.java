package store.seub2hu2.order.vo;

import lombok.*;
import store.seub2hu2.product.vo.Size;
import store.seub2hu2.user.vo.User;

import java.util.Date;

@ToString
@NoArgsConstructor
@AllArgsConstructor
@Setter
@Getter
public class Discount {
    private int no; // 할인 번호
    private String isProcess;  // 진행 여부
    private String discountName; // 할인 유형
    private Date discountDate; // 할인 기간
    private double discountRate; // 할인 비율
    private int discountPrice; // 할인 금액
    private User user; // 유저 번호
    private Size size; // 사이즈 번호(상품번호)
}
