package store.seub2hu2.course.dto;

import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import lombok.ToString;

@Getter
@Setter
@NoArgsConstructor
@ToString
public class SuccessCoursesForm {
    // 달성한 코스 목록을 표시할 때 사용하는 정보
    private int courseNo; // 코스 번호
    private String courseName; // 코스 이름
    private double distance; // 코스 거리
    private int level; // 코스 난이도
    private int userNo; // 사용자 번호
    private String nickname; // 사용자 닉네임
    private int successCount; // 각 코스 달성 횟수
}
