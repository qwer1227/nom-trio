package store.seub2hu2.wish.dto;

import lombok.*;
import store.seub2hu2.product.vo.*;
import store.seub2hu2.user.vo.User;

import java.util.List;

@ToString
@AllArgsConstructor
@NoArgsConstructor
@Setter
@Getter
public class WishItemDto {
    
    private int no; // 위시리스트 고유 번호
    private Color color; // 상품 색상
    private Size size; // 상품 사이즈
    private Product product; // 상품 객체
    private Category category; // 상품 카테고리
    private User user; // 유저 객체
    private List<Image> images; // 상품 사이즈
}
