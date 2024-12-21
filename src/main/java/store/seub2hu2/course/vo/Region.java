package store.seub2hu2.course.vo;

import lombok.*;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@ToString
public class Region {
    // 코스 지역 데이터
    private int no; // 지역 번호
    private String si; // 시
    private String gu; // 구
    private String dong; // 동
}
