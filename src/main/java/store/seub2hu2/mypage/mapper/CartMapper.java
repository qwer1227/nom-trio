package store.seub2hu2.mypage.mapper;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;
import store.seub2hu2.cart.dto.CartItemDto;
import store.seub2hu2.cart.dto.CartRegisterForm;
import store.seub2hu2.cart.vo.Cart;

import java.util.List;

@Mapper
public interface CartMapper {

    // 사용자에 따른 장바구니 목록 조회
    List<CartItemDto> getCartItemsByUserNo(@Param("userNo") int userNo);

    // 장바구니 추가 기능
    void addCart(@Param("carts") List<CartRegisterForm> cartRegisterForm);

    // 위시리스트에서 장바구니로 추가 기능
    void addToCart(@Param("cart") Cart cart);

    // 장바구니 삭제
    void deleteCartItems(@Param("cartNoList") List<Integer> cartNoList);

    Cart getCartByUserNoAndSizeNo(@Param("userNo") int userNo, @Param("sizeNo") int sizeNo);

    void updateCart(@Param("cart") Cart cart);
}
