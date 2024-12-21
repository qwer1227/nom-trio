package store.seub2hu2.course.dto;

import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import lombok.ToString;

@Getter
@Setter
@NoArgsConstructor
@ToString
public class AddRecordForm {
    // 완주 기록 입력할 때 사용하는 정보
    private int courseNo; // 코스 번호
    private String finishedDate; // 완주 날짜
    private int hour; // 완주 시간(시간)
    private int minute; // 완주 시간(분)
    private int second; // 완주 시간(초)
}
