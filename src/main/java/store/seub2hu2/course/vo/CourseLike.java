package store.seub2hu2.course.vo;

import lombok.*;
import store.seub2hu2.user.vo.User;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
@ToString
public class CourseLike {
    private Course course;
    private User user;
}
