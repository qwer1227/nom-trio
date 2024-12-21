package store.seub2hu2.lesson.dto;

import lombok.*;
import org.springframework.format.annotation.DateTimeFormat;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.Date;

@NoArgsConstructor
@AllArgsConstructor
@Getter
@Setter
public class ReservationSearchCondition {

    private String searchKeyword;
    private String searchCondition;
    private String lessonStatus;
    private String reservationStatus;
    private String lessonSubject;
    @DateTimeFormat(pattern = "yyyy-MM-dd")
    private LocalDate start;

    @DateTimeFormat(pattern = "yyyy-MM-dd")
    private LocalDate end;

    public String getStartDate() {
        return LocalDate.from(start).format(DateTimeFormatter.ofPattern("yyyy-MM-dd"));
    }

    public String getEndDate() {
        return LocalDate.from(end).format(DateTimeFormatter.ofPattern("yyyy-MM-dd"));
    }

}
