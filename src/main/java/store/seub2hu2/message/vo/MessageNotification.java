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
public class MessageNotification {

    private int notificationNo;      // 알림 번호
    private String receiverId;       // 메시지 수신자 ID
    private int messageNo;           // 메시지 번호
    private String content;          // 알림 내용
    private Date notificationCreatedDate; // 알림 생성 날짜
    private boolean isRead;          // 읽음 여부 (true: 읽음, false: 안 읽음)
}