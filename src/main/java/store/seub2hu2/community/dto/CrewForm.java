package store.seub2hu2.community.dto;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import org.springframework.web.multipart.MultipartFile;

@NoArgsConstructor
@AllArgsConstructor
@Getter
@Setter
public class CrewForm {

    private int no;
    private String name;
    private String location;
    private String type;
    private String detail;
    private String title;
    private String description;
    private MultipartFile image;
    private MultipartFile upfile;

    public String getSchedule() {
        return type + " " + detail;
    }
}