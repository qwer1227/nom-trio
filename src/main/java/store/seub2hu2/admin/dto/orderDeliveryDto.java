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
public class orderDeliveryDto {

    private int deliNo;
    private String deliCom;
    private String deliStatus;
    private String deliMemo;
    private String deliPhone;
    private String orderNumber;
    private String orderStatus;
    @JsonFormat(shape = JsonFormat.Shape.STRING, pattern = "yyyy-MM-dd HH:mm:ss")
    @DateTimeFormat(pattern = "yyyy-MM-dd")
    private LocalDateTime orderDate;
    private int deliPay;
    private int zipCode;
    private String addrName;
    private String addr1;
    private String addr2;
    private String payStatus;


    public String getOrderDate() {
        return LocalDateTime.from(orderDate).format(DateTimeFormatter.ofPattern("yyyy-MM-dd"));
    }

    public String getOrderTime() {
        return LocalDateTime.from(orderDate).format(DateTimeFormatter.ofPattern("HH:mm"));
    }


}
