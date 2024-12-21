package store.seub2hu2.security.service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.oauth2.client.userinfo.DefaultOAuth2UserService;
import org.springframework.security.oauth2.client.userinfo.OAuth2UserRequest;
import org.springframework.security.oauth2.client.userinfo.OAuth2UserService;
import org.springframework.security.oauth2.core.OAuth2AuthenticationException;
import org.springframework.security.oauth2.core.user.OAuth2User;
import org.springframework.stereotype.Service;
import store.seub2hu2.security.oauth.exception.OAuthProviderMissMatchException;
import store.seub2hu2.security.oauth.info.OAuth2UserInfo;
import store.seub2hu2.security.user.CustomOAuth2User;
import store.seub2hu2.security.oauth.info.OAuth2UserInfoFactory;
import store.seub2hu2.user.mapper.UserMapper;
import store.seub2hu2.user.vo.Role;
import store.seub2hu2.user.vo.User;
import store.seub2hu2.user.vo.UserRole;

import java.util.ArrayList;
import java.util.Date;
import java.util.List;

@Service
public class CustomOAuth2UserService implements OAuth2UserService<OAuth2UserRequest, OAuth2User> {

    @Autowired
    private UserMapper userMapper;

    // loadUser(OAuth2UserRequest userRequest) 메소드는 사용자 정보를 요청할 수 있는 access token을 얻고 나서 실행되는 메소드다
    // OAuth2UserRequest객체는 소셜에서 사용자 인증을 마친 최종 access token을 가지고 있다.
    @Override
    public OAuth2User loadUser(OAuth2UserRequest userRequest) throws OAuth2AuthenticationException {
        // 소셜에 사용자정보를 요청하는 OAuth2UserService객체를 획득한다.
        OAuth2UserService<OAuth2UserRequest, OAuth2User> delegate = new DefaultOAuth2UserService();

        // accessToken을 가지고 있는 OAuth2UserRequest객체로 소셜에 사용자 정보를 요청해서 OAuth2User(사용자 정보)객체를 획득한다.
        OAuth2User oAuth2User = delegate.loadUser(userRequest);

        // OAuth2의 registration id를 조회한다.(registtration id는 google, kakao 등이다.)
        String provider = userRequest.getClientRegistration().getRegistrationId();
        System.out.println("provider ----" +  provider);

        // OAuth2UserInfo객체에는 id, name, email이 포함되어 있다.(id값은 실제 아이디는 아니고, 임의의 문자열이다.)
        // OAuth2UserInfoFactory객체는 provider(google 혹은 kakao)와 oAuth2User.getAttributes()는 소셜에서 제공하는 사용자가 정보가 들어 있는 객체를 전달받아서
        // OAuth2UserInfo객체를 반환한다. OAuth2UserInfo객체는 provider에 따라서 GoogleOAuth2UserInfo, KakaoOAuth2UserInfo 객체 중에서 하나를 반환한다.
        OAuth2UserInfo userInfo = OAuth2UserInfoFactory.getOAuth2UserInfo(provider, oAuth2User.getAttributes());

        // getName() 값 확인
        String name = userInfo.getName();
        if (name == null || name.isEmpty()) {
            throw new IllegalStateException("OAuth2UserInfo.getName() returned null or empty.");
        }

        // 조회된 아이디로 사용자 정보를 조회한다.
        User savedUser = userMapper.getUserById(userInfo.getId());

        // 사용자가 정보가 존재하면 사용자정보를 업데이트한다. 존재하지 않으면 소셜로그인으로 획득한 사용자 정보를 저장한다.
        // 즉, 소셜로그인이 성공하면 자동으로 회원가입이 완료된다.
        Role role = new Role();
        role.setNo(2); // roleName을 "ROLE_USER"로 설정 (기본)
        role.setName("ROLE_USER");

        if (savedUser == null) {
            savedUser = createUser(userInfo, role, provider);
        }
        // 사용자 정보를 저장한 후, 제공자 정보 전달을 위해 속성 추가
        savedUser.setProvider(provider); // 로그인 제공자 정보 추가
        return new CustomOAuth2User(savedUser, role, userInfo.getAttributes());
    }

    private User createUser(OAuth2UserInfo userInfo, Role role, String provider) {
        User user = new User();
        user.setId(userInfo.getId());
        user.setNickname(userInfo.getName());
        user.setEmail(userInfo.getEmail());
        user.setProvider(provider);
        user.setCreatedDate(new Date());
        user.setUpdatedDate(new Date());

        userMapper.insertUser(user);

        UserRole userRole = new UserRole();
        userRole.setUserNo(user.getNo());
        userRole.setRole(role);

        userMapper.insertUserRole(userRole);

        return user;
    }

    private User updateUser(User user, OAuth2UserInfo userInfo) {
        if (userInfo.getName() != null && !user.getName().equals(userInfo.getName())) {
            user.setName(userInfo.getName());
        }
        userMapper.updateUser(user);

        return user;
    }
}

