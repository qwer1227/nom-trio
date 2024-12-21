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
public class Message {

    private int messageNo;
    private int userNo;              // 보낸 사람 번호
    private String senderNickname;   // 보낸 사람 닉네임
    private String receiverNickname; // 받는 사람 닉네임
    private String title;
    private String content;
    private Date createdDate;
    private Date updatedDate;
    private String deleted;
    private MessageFile messageFile;
    private String readStatus;

}

