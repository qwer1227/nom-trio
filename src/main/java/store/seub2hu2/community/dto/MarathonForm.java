package store.seub2hu2.community.dto;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import org.springframework.format.annotation.DateTimeFormat;
import org.springframework.web.multipart.MultipartFile;

import java.util.Date;

@NoArgsConstructor
@AllArgsConstructor
@Getter
@Setter
public class MarathonForm {

    private int no;
    private String title;
    @DateTimeFormat(pattern = "yyyy-MM-dd")
    private Date marathonDate;
    @DateTimeFormat(pattern = "yyyy-MM-dd")
    private Date startDate;
    @DateTimeFormat(pattern = "yyyy-MM-dd")
    private Date endDate;
    private String place;
    private String url;
    private String thumbnail;
    private String content;
    private MultipartFile upfile;
    private String organName;
    private String host;
    private String organizer;
}
