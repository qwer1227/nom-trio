package store.seub2hu2.course.vo;

import lombok.*;
import store.seub2hu2.user.vo.User;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@ToString
public class SuccessWhether {
    // 코스 성공 여부
    private int courseNo; // 코스 번호
    private User user; // 회원 번호
}
