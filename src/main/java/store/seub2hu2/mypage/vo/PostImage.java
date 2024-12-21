package store.seub2hu2.mypage.vo;

import lombok.*;
import org.apache.catalina.User;
import org.apache.ibatis.type.Alias;

@AllArgsConstructor
@NoArgsConstructor
@Getter
@Setter
@Alias("PostImage")
@ToString
public class PostImage {

    private int no;
    private String imageUrl;
    private User user;
}
