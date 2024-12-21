package store.seub2hu2.mypage.vo;

import lombok.*;

import store.seub2hu2.user.vo.User;

import java.awt.*;
import java.util.Date;
import java.util.List;

@NoArgsConstructor
@AllArgsConstructor
@Setter
@Getter
@ToString
public class Post {

    private int no;
    private String thumbnail;
    private String postContent;
    private char postDeleted;
    private Date postCreatedDate;
    private User user;
    private String userName;
    private List<PostComment> postComment;
    private List<PostImage> images;
    private String postCreatedDateString;  // 형식화된 날짜를 저장할 String 타입 필드



}
