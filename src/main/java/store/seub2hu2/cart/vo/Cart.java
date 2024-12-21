package store.seub2hu2.cart.vo;

import lombok.*;
import org.springframework.stereotype.Service;
import store.seub2hu2.product.vo.Color;
import store.seub2hu2.product.vo.Product;
import store.seub2hu2.product.vo.Size;
import store.seub2hu2.user.vo.User;

import java.util.Date;

@NoArgsConstructor
@AllArgsConstructor
@ToString
@Setter
@Getter
public class Cart {

    private int no; // 카트 번호
    private int amount; // 수량
    private Date createdAt; // 생성일자
    private boolean cartDeleted; // 삭제 여부
    private Size size;
    private Color color;
    private User user;
    private Product product;

}
