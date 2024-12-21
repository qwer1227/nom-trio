package store.seub2hu2.community.vo;

import com.fasterxml.jackson.annotation.JsonFormat;
import lombok.*;
import store.seub2hu2.mypage.vo.PostImage;
import store.seub2hu2.user.vo.User;

import java.util.Date;
import java.util.List;

@NoArgsConstructor
@AllArgsConstructor
@Getter
@Setter
@ToString
public class Reply {
    private int no;
    private int prevNo;
    private String type; // board, crew, course
    private int typeNo;  // board의 게시글 번호, crew의 게시글 번호, course의 게시글 번호
    private int crewNo;
    private String content;
    @JsonFormat(pattern = "yyyy-MM-dd")
    private Date createdDate;
    @JsonFormat(pattern = "yyyy-MM-dd")
    private Date updatedDate;
    private User user;
    private User prevUser; // 대댓글의 상위 답글을 쓴 유저
    private String report;
    private int replyLikeCnt; // 댓글 좋아요 갯수
    private int replyLiked; // 댓글 좋아요 클릭 여부
    private String deleted;
    private String image;
    private int boardNo;
}
