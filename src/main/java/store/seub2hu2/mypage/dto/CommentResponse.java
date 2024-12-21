package store.seub2hu2.mypage.dto;

import lombok.*;

import java.util.ArrayList;
import java.util.Date;
import java.util.List;

@NoArgsConstructor
@AllArgsConstructor
@Getter
@Setter
@ToString
public class CommentResponse {
    private int postNo;
    private int commentNo;
    private String commentText;
    private String authorName;
    private Date createdDate;
    private Integer replyCommentNo;
    private List<CommentResponse> replies;

}
