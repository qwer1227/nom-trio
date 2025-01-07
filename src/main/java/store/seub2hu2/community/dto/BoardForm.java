package store.seub2hu2.community.dto;

import lombok.*;
import org.springframework.web.multipart.MultipartFile;
import store.seub2hu2.community.vo.BoardCategory;

@NoArgsConstructor
@AllArgsConstructor
@Getter
@Setter
public class BoardForm {
    private int no;
    private BoardCategory category;
    private String title;
    private String content;
    private MultipartFile upfile;
}
