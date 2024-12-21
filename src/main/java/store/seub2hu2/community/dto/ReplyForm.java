package store.seub2hu2.community.dto;

import jakarta.validation.constraints.NotEmpty;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import store.seub2hu2.mypage.vo.PostImage;
import store.seub2hu2.user.vo.User;

@NoArgsConstructor
@Getter
@Setter
public class ReplyForm {

    private int no;     // 댓글 번호
    private int prevNo; // 원댓글 번호
    private String type;    // 댓글이 있는 게시글 타입
    private int typeNo;     // 게시글 번호
    private String content;
    private int userNo;
    private int crewNo;
    private int boardNo;
    private int id;
}
