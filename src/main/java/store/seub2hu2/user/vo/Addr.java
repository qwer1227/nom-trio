package store.seub2hu2.user.vo;

import lombok.*;
import org.apache.ibatis.type.Alias;

@ToString
@NoArgsConstructor
@AllArgsConstructor
@Setter
@Getter
@Alias("Addr")
public class Addr {

    private int no; // 주소 번호
    private String name; // 받는사람
    private String postcode; // 우편 번호
    private String address; // 주소 1
    private String addressDetail; // 상세주소
    private String isAddrHome; // 기본 주소 설정
    private int userNo;
}
