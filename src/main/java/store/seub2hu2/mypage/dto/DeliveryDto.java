package store.seub2hu2.mypage.dto;

import lombok.*;

@ToString
@AllArgsConstructor
@NoArgsConstructor
@Getter
@Setter
public class DeliveryDto {

    private int deliNo;
    private String deliCom;
    private String deliStatus;
    private String deliMemo;
    private String deliPhoneNumber;
}
