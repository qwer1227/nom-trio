package store.seub2hu2.mypage.vo;

import lombok.*;
import org.apache.ibatis.type.Alias;
import store.seub2hu2.mypage.dto.CommentRequest;
import store.seub2hu2.user.vo.User;

import java.util.Date;

@NoArgsConstructor
@AllArgsConstructor
@Getter
@Setter
@Alias("PostComment")
@ToString
public class PostComment {

    private int no;
    private Date createdDate;
    private PostComment parentComment;
    private CommentRequest commentRequest;
    private String userName;
}
