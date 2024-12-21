package store.seub2hu2.lesson.dto;

import lombok.*;
import org.springframework.format.annotation.DateTimeFormat;
import org.springframework.web.multipart.MultipartFile;
import store.seub2hu2.lesson.vo.Lesson;

import java.time.LocalDateTime;
import java.util.Date;
import java.util.List;


@AllArgsConstructor
@NoArgsConstructor
@Getter
@Setter
@ToString
public class LessonDto {

    private int lessonNo;
    private String title;
    private String name;
    private String lecturerName;
    private String subject;
    private int userNo;
    private String place;
    private String startDate;
    private String startTime;
    private String participant;
    private int price;

    public LessonDto(Lesson lesson) {

    }
}
