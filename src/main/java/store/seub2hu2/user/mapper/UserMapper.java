package store.seub2hu2.user.mapper;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;
import org.apache.ibatis.annotations.Select;
import org.springframework.security.core.parameters.P;
import store.seub2hu2.course.vo.UserLevel;
import store.seub2hu2.mypage.dto.UserInfoReq;
import store.seub2hu2.user.vo.*;

import java.util.List;

@Mapper
public interface UserMapper {

    // ID로 사용자 중복 여부 확인
    int countById(@Param("id") String id);

    // 이메일로 사용자 중복 여부 확인
    int countByEmail(@Param("email") String email);

    // 닉네임으로 사용자 중복 여부 확인
    int countByNickname(@Param("nickname") String nickname);

    // 신규 사용자 추가
    void insertUser(@Param("user") User user);

    // 신규 주소 데이터 삽입 후 생성된 주소 번호 반환
    void insertAddr(@Param("addr") Addr addr);

    // 사용자 역할 부여
    void insertUserRole(@Param("userRole") UserRole userRole);

    // 사용자 주소 저장
    void insertAddress(@Param("addr") Addr addr);

    // 사용자 정보 수정
    void updateUser(@Param("user") User user);

    // 사용자 ID로 사용자 조회
    User getUserById(@Param("id") String id);

    // 사용자 이메일로 사용자 조회
    User getUserByEmail(@Param("email") String email);

    // 사용자 닉네임으로 사용자 조회
    User getUserByNickname(@Param("nickname") String nickname);

    // 사용자 번호로 역할 정보 조회
    List<Role> getRolesByUserNo(@Param("userNo") int userNo);

    // 역할 이름으로 Role 객체 조회
    Role getRoleByName(@Param("roleName") String roleName);

    // 아이디와 이메일로 사용자 조회
    User findUserByIdAndEmail(@Param("id") String id, @Param("email") String email);

    // 비밀번호 업데이트 (임시 비밀번호 발급)
    void updatePassword(@Param("id") String id, @Param("email") String email);

    // 사용자 권한 번호로 사용자 조회(사용자 번호, 이름, 아이디)
    List<User> getUsersByRoleNo(@Param("roleNo") int roleNo);

    void updateAddrUserNo(@Param("addrNo") int addrNo, @Param("userNo") int userNo);

    List<User> findUsersByNickname(@Param("nickname") String nickname);

    void insertUserLevel(UserLevel userLevel);

    List<User> findUsersByPassword(@Param("password") String password);

    User findByUserNo(@Param("userNo") int userNo);

    void insertUserImage(@Param("user")UserImage userImage);

    void updatePrimaryToN(@Param("userNo") int userNo);

    void updateAddr(UserInfoReq userInfoReq);

    void updateIsAddrHomeToN(@Param("userNo") int userNo);

    List<Addr> findAddrByUserNo(@Param("userNo") int userNo);

    UserImage findImageByUserNo(@Param("userNo") int userNo);

    /*User findByNickname(@Param("userName") String userName);*/

}
