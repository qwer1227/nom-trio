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
public class OrderProductDto {

    private int payNo;
    private int orderNo;
    private String orderNum;
    private int orderProdNo;
    private String payType;
    private String userName;
    private String userId;
    private String userTel;
    private String payPrice;
    private String payStatus;
    private String payMethod;
    private String prodName;
    private String colorName;
    private String prodSize;
    private int orderProdAmount;
    @JsonFormat(shape = JsonFormat.Shape.STRING, pattern = "yyyy-MM-dd HH:mm:ss")
    @DateTimeFormat(pattern = "yyyy-MM-dd")
    private LocalDateTime payDate;
    private LocalDateTime payCancelDate;
    private int totalPrice;



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
