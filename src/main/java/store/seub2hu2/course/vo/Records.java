package store.seub2hu2.course.vo;

import com.fasterxml.jackson.annotation.JsonFormat;
import lombok.*;
import store.seub2hu2.user.vo.User;

import java.util.Date;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@ToString
public class Records {
    // 코스 완주 기록 데이터
    private int no; // 코스 완주 번호
    @JsonFormat(pattern = "yyyy년 MM월 dd일 HH시 mm분")
    private Date finishedDate; // 코스 완주 날짜
    private int hour; // 코스 완주 시간(시간)
    private int minute; // 코스 완주 시간(분)
    private int second; // 코스 완주 시간(초)
    private User user; // 회원 번호
    private Course course; // 코스 번호
}
