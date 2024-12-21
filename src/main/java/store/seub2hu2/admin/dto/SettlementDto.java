package store.seub2hu2.admin.dto;

import com.fasterxml.jackson.annotation.JsonFormat;
import lombok.*;
import org.springframework.format.annotation.DateTimeFormat;

import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;

@NoArgsConstructor
@AllArgsConstructor
@Getter
@Setter
@ToString
public class SettlementDto {

    private int payNo;
    private String settleType;
    private String name;
    private String id;
    private String title;
    private int price;
    private int totalPrice;
    private String payMethod;
    private String status;
    private String lessonSubject;
    private int lessonNo;
    @JsonFormat(shape = JsonFormat.Shape.STRING, pattern = "yyyy-MM-dd HH:mm:ss")
    @DateTimeFormat(pattern = "yyyy-MM-dd")
    private LocalDateTime payDate;
    private LocalDateTime payCancelDate;


    public String getPayDate() {
        return LocalDateTime.from(payDate).format(DateTimeFormatter.ofPattern("yyyy-MM-dd"));
    }

    public String getPayTime() {
        return LocalDateTime.from(payDate).format(DateTimeFormatter.ofPattern("HH:mm"));
    }

    public String getPayCancelDate() {
        return LocalDateTime.from(payCancelDate).format(DateTimeFormatter.ofPattern("yyyy-MM-dd"));
    }

    public String getPayCancelTime() {
        return LocalDateTime.from(payCancelDate).format(DateTimeFormatter.ofPattern("HH:mm"));
    }
}
