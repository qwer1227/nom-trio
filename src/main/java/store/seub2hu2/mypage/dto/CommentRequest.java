package store.seub2hu2.mypage.dto;

import lombok.*;

@NoArgsConstructor
@AllArgsConstructor
@Getter
@Setter
@ToString
public class CommentRequest {
    private int postId;           // 게시글 ID
    private String postComment;   // 댓글 내용
    private int userNo;           // 댓글 작성자 (사용자 번호)
    private int replyToUserNo;    // 대댓글 대상 사용자 번호
    private Integer replyToCommentNo; // 대댓글이 달릴 댓글 번호
}
