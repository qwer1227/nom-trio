package store.seub2hu2.admin.dto;


import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import org.springframework.web.multipart.MultipartFile;
import store.seub2hu2.course.vo.Region;

@NoArgsConstructor
@Getter
@Setter
public class CourseRegisterForm {
    private int no;
    private String name;
    private int time;
    private Double distance;
    private int level;
    private MultipartFile image;
    private String si;
    private String gu;
    private String dong;
}
