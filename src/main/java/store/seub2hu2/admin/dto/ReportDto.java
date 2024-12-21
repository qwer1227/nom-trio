package store.seub2hu2.admin.dto;

import com.fasterxml.jackson.annotation.JsonFormat;
import lombok.*;
import org.springframework.format.annotation.DateTimeFormat;

import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;

@ToString
@NoArgsConstructor
@AllArgsConstructor
@Setter
@Getter
public class ReportDto {
    private int reportId;
    private String reportType;
    private int reportNo;
    private String userName;
    private String userNickname;
    @JsonFormat(shape = JsonFormat.Shape.STRING, pattern = "yyyy-MM-dd HH:mm:ss")
    @DateTimeFormat(pattern = "yyyy-MM-dd")
    private LocalDateTime reportDate;
    private LocalDateTime reportResolveDate;
    private String reportReason;
    private String isComplete;

    public String getReportDate() {
        return LocalDateTime.from(reportDate).format(DateTimeFormatter.ofPattern("yyyy-MM-dd"));
    }

    public String getReportTime() {
        return LocalDateTime.from(reportDate).format(DateTimeFormatter.ofPattern("HH:mm"));
    }

//    public String getReportResolveDate() {
//        return LocalDateTime.from(reportResolveDate).format(DateTimeFormatter.ofPattern("yyyy-MM-dd"));
//    }

//    public String getReportResolveTime() {
//        return LocalDateTime.from(reportResolveDate).format(DateTimeFormatter.ofPattern("HH:mm"));
//    }
}
