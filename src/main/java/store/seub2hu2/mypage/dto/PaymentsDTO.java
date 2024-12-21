package store.seub2hu2.mypage.dto;

import lombok.*;

import java.util.Date;

@NoArgsConstructor
@AllArgsConstructor
@ToString
@Getter
@Setter
public class PaymentsDTO {
    private int payNo;
    private String payId;
    private String payMethod;
    private int payAmount;
    private Date payDate;
    private String payType;
    private String refund;
}
