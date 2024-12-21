package store.seub2hu2.product.vo;

import lombok.*;

import java.util.Date;

@ToString
@NoArgsConstructor
@AllArgsConstructor
@Setter
@Getter
public class ProdReview {
    private int no;
    private int prodNo;
    private int userNo;
    private String title;
    private String content;
    private Date createdDate;
    private Date updatedDate;
    private int rating;
    private String isDeleted;
}
