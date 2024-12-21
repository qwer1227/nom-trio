package store.seub2hu2.course.dto;

import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import lombok.ToString;

@Getter
@Setter
@NoArgsConstructor
@ToString
public class SuccessCountRankForm {
    // 코스 달성 수 순위를 표시할 때 사용하는 정보
    private int userNo; // 사용자 번호
    private String nickName; // 사용자 닉네임
    private int successCount; // 코스 달성 수
    private int ranking; // 코스 달성 수 순위
}
