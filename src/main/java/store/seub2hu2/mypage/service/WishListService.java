package store.seub2hu2.mypage.service;

import lombok.RequiredArgsConstructor;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import store.seub2hu2.mypage.mapper.WishMapper;
import store.seub2hu2.product.vo.Color;
import store.seub2hu2.product.vo.Product;
import store.seub2hu2.product.vo.Size;
import store.seub2hu2.wish.dto.WishItemDto;
import store.seub2hu2.wish.vo.WishList;

import java.util.List;

@Service
@RequiredArgsConstructor
public class WishListService {

    private final WishMapper wishMapper;

    /**
     * 전체 조회
     * @param userNo 유버 번호
     * @return 해당 유저가 저장한 위시리스트
     */
    public List<WishItemDto> getWishListByUserNo(int userNo) {

        List<WishItemDto> wishList = wishMapper.getWishListByUserNo(userNo);

        return wishList;
    }

    /**
     * 상품 상세페이지에서 위시리스트 정보 저장
     * @param wishLists 위시리스트 정보
     */
    public void insertWishItems(List<WishList> wishLists) {
        if (wishLists == null || wishLists.isEmpty()) {
            throw new IllegalArgumentException("위시리스트 데이터가 비어 있습니다.");
        }

        // Mapper 호출
        wishMapper.insertWishItems(wishLists);
    }

    /**
     * 삭제
     * @param wishNo 위시리스트 번호
     */
    public void deleteWishListItemByNo(int wishNo) {
        wishMapper.deleteWishItem(wishNo);
    }
}
