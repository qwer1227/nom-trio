package store.seub2hu2.user.dto;

import lombok.*;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@ToString
public class MailDTO {
    private String id;    // 사용자 ID
    private String email; // 사용자 이메일
}
