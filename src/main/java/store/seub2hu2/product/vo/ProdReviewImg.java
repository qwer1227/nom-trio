package store.seub2hu2.product.vo;

import lombok.*;

import java.util.Date;

@ToString
@NoArgsConstructor
@AllArgsConstructor
@Setter
@Getter
public class ProdReviewImg {
    private int no;
    private String imgName;
    private Date cratedDate;
    private int reviewNo;
}
