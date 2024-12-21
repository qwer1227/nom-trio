package store.seub2hu2.mypage.mapper;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;
import org.springframework.security.core.parameters.P;
import store.seub2hu2.wish.dto.WishItemDto;
import store.seub2hu2.wish.vo.WishList;

import java.util.List;

@Mapper
public interface WishMapper {
    
    // 특정 사용자의 위시리스트 가져오기
    List<WishItemDto> getWishListByUserNo(@Param("userNo") int userNo);
    
    // 위시리스트 저장하기
    void insertWishItems(@Param("wishLists") List<WishList> wishLists);
    
    // 위시리스트 삭제하기
    void deleteWishItem(@Param("wishNo") int wishNo);

}
