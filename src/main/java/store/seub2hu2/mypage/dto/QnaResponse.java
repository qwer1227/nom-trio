package store.seub2hu2.mypage.dto;

import lombok.*;
import store.seub2hu2.mypage.enums.QnaStatus;
import store.seub2hu2.user.vo.User;

import java.util.Date;

@NoArgsConstructor
@AllArgsConstructor
@ToString
@Getter
@Setter
public class QnaResponse {
    private int qnaNo;
    private String qnaTitle;
    private String qnaContent;
    private QnaStatus qnaStatus;
    private String answerContent;
    private Date answerCreatedDate;
    private Date qnaCreatedDate;
    private Date qnaUpdatedDate;
    private Date qnaAnswerdDate;
    private char qnaIsDeleted;
    private int questionUserNo;
    private int categoryNo;
    private int answerUserNo;
    private QnaCategory qnaCategory;
    private User user;
}
