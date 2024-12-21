package store.seub2hu2.message.dto;

import lombok.*;
import org.springframework.web.multipart.MultipartFile;

@NoArgsConstructor
@AllArgsConstructor
@Getter
@Setter
@ToString
public class MessageForm {
    private int messageNo;
    private int userNo; // 작성자 사용자 번호 (추가)
    private String senderId;  // 작성자 ID
    private String nickname;  // 작성자 닉네임
    private String receivers; // 받는 사람
    private String title;    // 제목
    private String content;  // 내용
    private MultipartFile file;
}

