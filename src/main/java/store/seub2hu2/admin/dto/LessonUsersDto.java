package store.seub2hu2.admin.dto;

import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import lombok.ToString;

@ToString
@NoArgsConstructor
@Getter
@Setter
public class LessonUsersDto {

    private String id;
    private int no;
    private int participant;
    private String name;
    private String nickname;
    private String email;
    private String tel;
    private String lessonStatus;

}
