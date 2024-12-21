package store.seub2hu2.mypage.dto;


import lombok.*;
import store.seub2hu2.user.vo.Addr;

@NoArgsConstructor
@AllArgsConstructor
@ToString
@Getter
@Setter
public class UserInfoReq {
    private String name;
    private String password;
    private String confirmPassword;
    private String nickname;
    private String phone;
    private String email;
    private int addrNo; // 주소 번호
    private String postcode; // 우편 번호
    private String address; // 주소 1
    private String addressDetail; // 상세주소
    private String isAddrHome; // 기본 주소 설정
    private int userNo;
}
