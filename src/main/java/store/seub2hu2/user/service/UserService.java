package store.seub2hu2.user.service;

import org.springframework.beans.BeanUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.authentication.AuthenticationManager;
import org.springframework.security.authentication.BadCredentialsException;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import store.seub2hu2.course.vo.UserLevel;
import store.seub2hu2.mypage.dto.UserInfoReq;
import store.seub2hu2.security.user.LoginUser;
import store.seub2hu2.user.dto.UserJoinForm;
import store.seub2hu2.user.exception.AlreadyUsedIdException;
import store.seub2hu2.user.mapper.UserMapper;
import store.seub2hu2.user.vo.*;

import java.util.List;

@Service
@Transactional
public class UserService {

    @Autowired
    private AuthenticationManager authenticationManager;

    @Autowired
    private PasswordEncoder passwordEncoder; // PasswordEncoder bean 등록

    @Autowired
    private UserMapper userMapper;

    public boolean checkDuplicateId(String id) {
        int count = userMapper.countById(id); // 아이디 존재 여부 확인
        return count > 0;
    }

    public boolean checkDuplicateEmail(String email) {
        int count = userMapper.countByEmail(email); // 이메일 존재 여부 확인
        return count > 0;
    }

    public boolean checkDuplicateNickname(String nickname) {
        System.out.println("checkDuplicateNickname method is called!"); // 메서드 호출 여부 확인
        if (nickname == null || nickname.trim().isEmpty()) {
            System.out.println("Received nickname is null or empty!");
        } else {
            System.out.println("Received nickname: " + nickname); // 디버깅용 로그 추가
        }
        int count = userMapper.countByNickname(nickname);
        System.out.println("Count of nicknames: " + count); // 결과 출력
        return count > 0;
    }




    /**
     * 신규 사용자 정보를 전달받아서 회원가입 시키는 서비스
     *
     * @param form 사용자 가입 정보를 담고 있는 UserJoinForm 객체
     */
    @Transactional // 트랜잭션 적용
    public void insertUser(UserJoinForm form) {

        // User 객체 생성 및 설정
        User user = new User();
        BeanUtils.copyProperties(form, user); // UserJoinForm의 데이터를 User로 복사
        user.setPassword(passwordEncoder.encode(user.getPassword())); // 비밀번호 암호화

        // 사용자 등록
        userMapper.insertUser(user); // DB에 삽입된 후 user.no가 자동 생성됨

        // Addr 객체 생성 및 설정
        Addr addr = new Addr();
        if (form.getPostcode() == null || form.getPostcode().isEmpty()) {
            throw new IllegalArgumentException("우편번호는 필수 입력 항목입니다.");
        }
        addr.setPostcode(form.getPostcode());             // 우편번호
        addr.setAddress(form.getAddress());             // 기본 주소
        addr.setAddressDetail(form.getAddressDetail() != null ? form.getAddressDetail() : ""); // 상세 주소
        addr.setIsAddrHome("Y");                         // 회원가입 시 기본 배송지로 설정
        addr.setName(form.getName());                    // 사용자 이름 설정
        addr.setUserNo(user.getNo());                    // 생성된 사용자 번호로 설정

        // 주소 등록
        userMapper.insertAddr(addr);

        // 사용자의 주소번호를 새로 등록한 주소의 번호로 없데이트 한다.
        userMapper.updateAddrUserNo(addr.getNo(), user.getNo());

        // 기본 사용자 역할 부여
        addUserRole(user.getNo(), "ROLE_USER");

        // 기본 사용자 레벨 부여
        UserLevel userLevel = new UserLevel();
        userLevel.setUserNo(user.getNo());  // 등록된 사용자 번호
        userLevel.setLevel(1);             // 기본 레벨 설정 (예: 1)
        userMapper.insertUserLevel(userLevel);  // 사용자 레벨 등록

        // 기본 사용자 이미지 등록
        UserImage userImage = new UserImage();
        userImage.setUserNo(user.getNo()); // 생성된 사용자 번호

        // 기본 이미지 URL 설정
        userImage.setImgName("primaryImage.jpg"); // 기본 이미지 이름
        userImage.setIsPrimary('Y'); // 기본 이미지로 설정

        // 사용자 이미지 DB에 등록
        userMapper.insertUserImage(userImage);
    }

    /**
     * 사용자번호, 권한이름을 전달받아서 권한을 추가하는 서비스
     *
     * @param userNo   사용자번호
     * @param roleName 권한이름
     */
    public void addUserRole(int userNo, String roleName) {
        // roleName을 통해 Role 객체를 조회
        Role role = userMapper.getRoleByName(roleName); // 역할 이름을 통해 Role 객체를 조회하는 메서드

        // Role 객체를 UserRole에 포함시켜 역할 부여
        UserRole userRole = new UserRole(userNo, role);

        // 사용자 역할 추가 메서드 호출
        userMapper.insertUserRole(userRole);
    }

    public boolean verifyPassword(String password, LoginUser loginUser) {

        // 로그인한 사용자 정보 가져오기
        User user = userMapper.getUserById(loginUser.getId());

        // 입력된 비밀번호 확인
        if (passwordEncoder.matches(password, user.getPassword())) {
            return true;
        }

        return false;
    }

    /**
     * @param userInfoReq 사용자가 입력한 내용
     * @return 참 여부
     */
    public int updateUser(UserInfoReq userInfoReq, LoginUser loginUser) {

        // userId를 사용해 유저 정보를 조회
        User user = userMapper.getUserById(loginUser.getId());

        // 입력한 비밀번호 인코딩
        String EncodedPwd = passwordEncoder.encode(userInfoReq.getPassword());

        // 사용자가 입력한 정보를 USER객체에 저장
        user.setNo(loginUser.getNo());
        user.setName(userInfoReq.getName());
        user.setNickname(userInfoReq.getNickname());
        user.setPassword(EncodedPwd);
        user.setTel(userInfoReq.getPhone());
        user.setEmail(userInfoReq.getEmail());

        if(userInfoReq.getAddrNo() != 0){
            userMapper.updateIsAddrHomeToN(user.getNo());
            userMapper.updateAddr(userInfoReq);
        }

        // 이전비밀번호 중복입력검증
        if (userInfoReq.getPassword().equals(user.getPassword())) {
            return 1;
        }

        // 비밀번호확인 검증
        if (!userInfoReq.getPassword().equals(userInfoReq.getConfirmPassword())) {
            return 2;
        }

        // 저장한 객체를 Mapper에 전달
        userMapper.updateUser(user);

        return 0;
    }

    public User findbyUserId(String userId) {
        return userMapper.getUserById(userId);
    }

    /**
     * 권한 번호로 해당 권한을 가진 사용자 목록을 조회하는 서비스
     *
     * @param roleNo 권한번호
     * @return 조회된 사용자 목록 반환
     */
    public List<User> findUsersByUserRoleNo(int roleNo) {
        List<User> findUsers = userMapper.getUsersByRoleNo(roleNo);
        return findUsers;
    }

    public LoginUser authenticateUser(String id, String password) throws BadCredentialsException {
        // userMapper를 통해 아이디로 사용자 조회
        User user = userMapper.getUserById(id);
        if (user == null) {
            throw new BadCredentialsException("아이디가 존재하지 않습니다.");
        }

        // 비밀번호가 일치하지 않으면
        if (!passwordEncoder.matches(password, user.getPassword())) {
            throw new BadCredentialsException("비밀번호가 맞지 않습니다.");
        }

        // 인증 처리
        Authentication authentication = authenticationManager.authenticate(
                new UsernamePasswordAuthenticationToken(id, password)
        );

        SecurityContextHolder.getContext().setAuthentication(authentication);

        return (LoginUser) authentication.getPrincipal();
    }



    public List<User> searchUsersByNickname(String nickname) {
        return userMapper.findUsersByNickname(nickname);
    }

    public boolean updateNickname(String nickname){

        List<User> users = searchUsersByNickname(nickname.trim());

        for (User user : users) {
            if(user.getNickname().equals(nickname)){
                return false;
            }
        }
        return true;
    }

    public User findbyUserNo(int userNo){
        return userMapper.findByUserNo(userNo);
    }

    public boolean isSameAsOldPassword(String password, int userNo){

        User user = findbyUserNo(userNo);

        if(passwordEncoder.matches(password, user.getPassword())){
            return true;
        } else {
            return false;
        }
    }

    public List<Addr> findAddrByUserNo(int userNo){

        return userMapper.findAddrByUserNo(userNo);

    }

    public UserImage findImageByUserNo(int userNo){

        return userMapper.findImageByUserNo(userNo);
    }

    public User findByNickname(String userName){

        return userMapper.getUserByNickname(userName);
    }

}