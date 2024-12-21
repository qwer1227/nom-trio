package store.seub2hu2.mypage.dto;

import lombok.*;
import store.seub2hu2.product.vo.Category;

@NoArgsConstructor
@AllArgsConstructor
@ToString
@Getter
@Setter
public class QnaCreateRequest {
    private int categoryNo;
    private String qnaTitle;
    private String qnaContent;
    private int questionUserNo;
}
