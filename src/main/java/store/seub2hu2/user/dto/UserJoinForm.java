package store.seub2hu2.user.dto;

import jakarta.validation.constraints.Email;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.Pattern;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import lombok.ToString;
import store.seub2hu2.user.vo.Addr;

@NoArgsConstructor
@Getter
@Setter
@ToString
public class UserJoinForm {

    private String id;
    private String password;
    private String passwordConfirm;
    private String email;
    private String nickname;
    private String tel;
    private String postcode;        // HTML name="postcode"
    private String address;         // HTML name="address"
    private String addressDetail = "";   // HTML name="address-detail"
    private String name;
    private String type;  // 로그인 타입 (일반/소셜 등)
    private String provider;  // 소셜 로그인 제공자 (예: google, facebook 등)
    private boolean terms;  // 이용약관 동의
    private boolean privacy;  // 개인정보 수집 및 이용 동의
}
