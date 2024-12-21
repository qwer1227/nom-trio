package store.seub2hu2.course.vo;

import lombok.*;
import store.seub2hu2.user.vo.User;

import java.util.Date;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@ToString
public class UserBadge {
    // 사용자 배지 현황 데이터
    private Badge badge; // 배지 번호
    private Date obtainTime; // 배지 획득 시간
    private User user; // 회원 번호
}
