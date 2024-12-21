package store.seub2hu2.user.vo;

import lombok.*;
import org.springframework.web.multipart.MultipartFile;

import java.util.Date;

@NoArgsConstructor
@AllArgsConstructor
@ToString
@Getter
@Setter
public class UserImage {
    private int no;
    private MultipartFile file;
    private String imgName;
    private Date createdDate;
    private char isPrimary;
    private int userNo;
}
