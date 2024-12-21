package store.seub2hu2.community.vo;

import com.fasterxml.jackson.annotation.JsonFormat;
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
public class Report {

    private int id;
    private int no;
    private String type;
    private String reason;
    private User user;
    @JsonFormat(pattern = "yyyy-MM-dd")
    private Date createdDate;
    @JsonFormat(pattern = "yyyy-MM-dd")
    private Date resolvedDate;
}
