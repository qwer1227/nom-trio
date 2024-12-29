package store.seub2hu2.lesson.vo;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

import java.time.LocalDateTime;

@AllArgsConstructor
@NoArgsConstructor
@Setter
@Getter
public class KakaopayAuthResVo {
    private String tid;
    private String next_redirect_mobile_url;
    private String next_redirect_pc_url;
    private LocalDateTime created_at;
}