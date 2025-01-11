package store.seub2hu2.community.dto;

import lombok.*;
import org.springframework.web.multipart.MultipartFile;
import store.seub2hu2.community.enums.BoardCategory;

@NoArgsConstructor
@AllArgsConstructor
@Getter
@Setter
public class BoardForm {
    private int no;
    private int catNo;
    private String title;
    private String content;
    private MultipartFile upfile;
}
