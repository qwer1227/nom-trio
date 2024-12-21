package store.seub2hu2.mypage.dto;

import lombok.*;

@ToString
@AllArgsConstructor
@NoArgsConstructor
@Setter
@Getter
public class AddrDto {

    private int addrNo;
    private String addrName;
    private String addrTel;
    private String postcode;
    private String addr;
    private String addrDetail;
}
