package store.seub2hu2.message.vo;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

import java.util.Date;

@NoArgsConstructor
@AllArgsConstructor
@Getter
@Setter
public class MessageReceivers {

    private int messageRcvNo;
    private int messageNo;
    private int userNo;
    private String isRead;
    private Date readDate;
    private Date updatedDate;
    private String isDelete;

}
