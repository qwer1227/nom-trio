package store.seub2hu2.admin.dto;


import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import org.springframework.web.bind.annotation.RequestParam;

@NoArgsConstructor
@Getter
@Setter
public class ImageUrlDto {
    private Integer imgNo;
    private String url;
}
