package store.seub2hu2.user.vo;

import lombok.*;
import org.apache.ibatis.type.Alias;

import java.util.Date;

@NoArgsConstructor
@AllArgsConstructor
@Builder
@Getter
@Setter
@ToString
@Alias("User")
public class User {

    private int no;                   // 유저 고유 ID (DB 기본키)
    private String id;                // 로그인용 ID (사용자 입력 아이디, 소셜 로그인 아이디도 동일하게 사용)
    private String name;              // 사용자 실명 (실제 이름)
    private String password;          // 비밀번호 (암호화된 상태로 저장)
    private String email;             // 이메일 (로그인용 이메일)
    private String nickname;          // 닉네임 (사용자 별명, 소셜 로그인 시 제공될 수도 있음)
    private String tel;               // 전화번호
    private String type;              // 로그인 타입 (일반/소셜 등)
    private String provider;          // 소셜 로그인 제공자 (예: Google, Facebook 등)
    private boolean terms;            // 이용약관 동의 여부
    private boolean privacy;          // 개인정보 수집 및 이용 동의 여부
    private String black;             // 블랙리스트
    private Addr addr;
    private String imgName;


    @Builder.Default
    private Date createdDate = new Date();  // 계정 생성일, 기본값으로 현재 시간 설정

    @Builder.Default
    private Date updatedDate = new Date();  // 계정 수정일, 기본값으로 현재 시간 설정
}
