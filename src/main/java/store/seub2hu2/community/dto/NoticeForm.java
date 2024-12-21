package store.seub2hu2.community.dto;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import org.springframework.web.multipart.MultipartFile;
import store.seub2hu2.community.vo.UploadFile;

@NoArgsConstructor
@AllArgsConstructor
@Getter
@Setter
public class NoticeForm {

    private int no;
    private String category;
    private boolean first;
    private String title;
    private String content;
    private MultipartFile upfile;
}
