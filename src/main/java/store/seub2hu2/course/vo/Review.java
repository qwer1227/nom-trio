package store.seub2hu2.course.vo;

import com.fasterxml.jackson.annotation.JsonFormat;
import lombok.*;
import store.seub2hu2.user.vo.User;

import java.util.Date;
import java.util.List;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@ToString
public class Review {
    // 코스 리뷰 데이터
    private int no; // 리뷰 번호
    private String title; // 리뷰 제목
    private String content; // 리뷰 내용
    private int likeCnt; // 좋아요 수
    @JsonFormat(pattern = "yyyy년 MM월 dd일 HH시 mm분")
    private Date createdDate; // 작성날짜
    @JsonFormat(pattern = "yyyy년 MM월 dd일")
    private Date updatedDate; // 수정날짜
    private String isDeleted; // 삭제여부
    private User user; // 회원번호
    private Course course; // 코스번호
    private List<ReviewImage> reviewImage; // 리뷰 첨부 파일
}
