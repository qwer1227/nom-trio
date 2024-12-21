package store.seub2hu2.course.dto;

import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import lombok.ToString;
import org.springframework.web.multipart.MultipartFile;

import java.util.List;

@Getter
@Setter
@NoArgsConstructor
@ToString
public class AddReviewForm {
    // 리뷰 작성할 때 사용되는 정보
    private int courseNo; // 코스 번호
    private String title; // 리뷰 제목
    private String content; // 리뷰 내용
    List<MultipartFile> upfiles; // 첨부 파일
}
