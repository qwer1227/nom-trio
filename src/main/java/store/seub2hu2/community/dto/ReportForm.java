package store.seub2hu2.community.dto;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import store.seub2hu2.user.vo.User;

@NoArgsConstructor
@AllArgsConstructor
@Getter
@Setter
public class ReportForm {
    private String type;
    private int no;
    private int userNo;
    private String reason;
}
