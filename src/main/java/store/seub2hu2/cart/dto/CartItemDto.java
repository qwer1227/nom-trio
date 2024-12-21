package store.seub2hu2.cart.dto;

import lombok.*;
import store.seub2hu2.product.vo.Color;
import store.seub2hu2.product.vo.Product;
import store.seub2hu2.product.vo.Size;
import store.seub2hu2.user.vo.User;

@ToString
@AllArgsConstructor
@NoArgsConstructor
@Setter
@Getter
public class CartItemDto {

    private int no;
    private int stock;
    private Product product;
    private Color color;
    private Size size;
    private User user;
    private String imgThum;
}
