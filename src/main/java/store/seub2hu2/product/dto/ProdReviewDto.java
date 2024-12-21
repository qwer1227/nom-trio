package store.seub2hu2.product.dto;

import lombok.*;
import store.seub2hu2.product.vo.ProdReviewImg;

import java.util.Date;
import java.util.List;

@ToString
@NoArgsConstructor
@AllArgsConstructor
@Setter
@Getter
public class ProdReviewDto {

    // 리뷰 정보
    private int reviewNo;
    private String reviewTitle;
    private String reviewContent;
    private int rating;
    private Date reviewDate;

    // 리뷰이미지
    private List<ProdReviewImg> prodReviewImgs;

    // 상품
    private int prodNo;
    private String prodName;

    // 색상
    private int colorNo;
    private String colorName;


    private int userNo;
    private String userName;
    private String userNickname;
}
