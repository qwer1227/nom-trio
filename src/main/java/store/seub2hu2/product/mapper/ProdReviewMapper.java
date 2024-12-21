package store.seub2hu2.product.mapper;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;
import store.seub2hu2.product.dto.ProdReviewDto;
import store.seub2hu2.product.vo.ProdReview;
import store.seub2hu2.product.vo.ProdReviewImg;

import java.util.List;

@Mapper
public interface ProdReviewMapper {

    List<ProdReviewDto> prodReviewDto(@Param("prodNo") int prodNo);

    ProdReview getProdReviewByNo(@Param("reviewNo") int reviewNo);

    void insertProdReview(@Param("review") ProdReview prodReview);

    void insertProdReviewsImg(ProdReviewImg prodReviewImg);

    void updateProdReview(@Param("review") ProdReview prodReview);

    void deleteProdReview(@Param("reviewNo") int reviewNo);

    // 특정 상품의 리뷰 평균 평점을 계산
    double calculateAverageRatingByProdNo(@Param("prodNo") int prodNo);
}
