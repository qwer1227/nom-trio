package store.seub2hu2.mypage.dto;

import lombok.*;
import store.seub2hu2.mypage.enums.QnaStatus;

import java.util.Date;

@NoArgsConstructor
@AllArgsConstructor
@ToString
@Getter
@Setter
public class AnswerDTO {
    private int qnaNo;
    private int qnaStatus;
    private String answerContent;
    private Date answerCreatedDate;
}
