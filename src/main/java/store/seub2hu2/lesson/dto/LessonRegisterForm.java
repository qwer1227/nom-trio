package store.seub2hu2.lesson.dto;

import com.fasterxml.jackson.annotation.JsonFormat;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import org.springframework.format.annotation.DateTimeFormat;
import org.springframework.web.multipart.MultipartFile;

import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.Date;


@NoArgsConstructor
@AllArgsConstructor
@Getter
@Setter
public class LessonRegisterForm {

    @NotBlank(message = "레슨명을 입력해 주세요")
    private String title;
    @NotNull(message = "가격을 입력해 주세요")
    private Integer price;
    private int lecturerNo;
    private String lecturerId;
    private String subject;
    private String lecturerName;
    private int group;

    @NotNull(message = "장소를 입력해 주세요")
    private String place;
    private String status;
    private String plan;
    private MultipartFile thumbnail;
    private MultipartFile mainImage;


    @NotBlank(message = "시작 날짜는 필수입니다.")
    @JsonFormat(pattern = "yyyy-MM-dd HH:mm")
    @DateTimeFormat(pattern = "yyyy-MM-dd HH:mm")
    private String startDate;

    @NotBlank(message = "종료 날짜는 필수입니다.")
    @JsonFormat(pattern = "yyyy-MM-dd HH:mm")
    @DateTimeFormat(pattern = "yyyy-MM-dd HH:mm")
    private String endDate;

    public LocalDateTime getStart() {
        startDate = startDate.replace("T", " ");

        return LocalDateTime.parse(startDate, DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm"));
    }

    public LocalDateTime getEnd() {
        endDate = endDate.replace("T", " ");

        return LocalDateTime.parse(endDate, DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm"));
    }

}
