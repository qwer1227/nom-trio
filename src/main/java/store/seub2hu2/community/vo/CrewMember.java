package store.seub2hu2.community.vo;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import store.seub2hu2.user.vo.User;

import java.util.Date;

@NoArgsConstructor
@AllArgsConstructor
@Getter
@Setter
public class CrewMember {

    private int crewNo;
    private User user;
    private String reader;
    private Date joinDate;
    private String join;
}
