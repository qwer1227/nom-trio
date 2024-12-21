package store.seub2hu2.product.dto;

import lombok.*;
import org.springframework.web.multipart.MultipartFile;

import java.util.List;

@ToString
@NoArgsConstructor
@AllArgsConstructor
@Setter
@Getter
public class ProdReviewForm {

    private int prodNo;
    private int colorNo;
    private int rating;
    private String title;
    private String content;
    List<MultipartFile> reviewFiles;

}
