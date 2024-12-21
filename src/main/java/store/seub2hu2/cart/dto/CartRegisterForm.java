package store.seub2hu2.cart.dto;

import lombok.*;

@ToString
@AllArgsConstructor
@NoArgsConstructor
@Setter
@Getter
public class CartRegisterForm {

    private int no; // 장바구니 번호
    private int stock; // 수량
    private int userNo; // 유저 번호
    private int sizeNo; // 사이즈 번호
    private int colorNo; // 색상 번호
    private int prodNo; // 상품 번호
}
