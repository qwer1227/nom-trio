package store.seub2hu2.lesson.dto;

import com.fasterxml.jackson.annotation.JsonFormat;

import jakarta.validation.constraints.Min;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotEmpty;
import jakarta.validation.constraints.NotNull;
import lombok.*;
import org.springframework.format.annotation.DateTimeFormat;
import org.springframework.web.multipart.MultipartFile;

import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;

@Getter
@Setter
@AllArgsConstructor
@NoArgsConstructor
@ToString
public class LessonUpdateForm {

    private int lessonNo;

    @NotBlank(message = "레슨명을 입력해 주세요")
    private String title;

    private String lecturerId;
    private String subject;
    private String status;
    private int participant;


    private String plan;

    @NotNull(message = "가격을 입력해 주세요")
    @Min(value=1, message = "가격은 최소 1 이상이어야 합니다.")
    private Integer price;

    private MultipartFile thumbnail;

    private MultipartFile mainImage;

    @NotBlank(message = "시작 날짜는 필수입니다.")
    @JsonFormat(pattern = "yyyy-MM-dd HH:mm")
    @DateTimeFormat(pattern = "yyyy-MM-dd HH:mm")
    private String start;

    @NotBlank(message = "종료 날짜는 필수입니다.")
    @JsonFormat(pattern = "yyyy-MM-dd HH:mm")
    @DateTimeFormat(pattern = "yyyy-MM-dd HH:mm")
    private String end;


}
