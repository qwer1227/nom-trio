package store.seub2hu2.security.oauth.info;

import java.util.Map;

public class KakaoOAuth2UserInfo extends OAuth2UserInfo {

    public KakaoOAuth2UserInfo(Map<String, Object> attributes) {
        super(attributes);
    }

    @Override
    public String getId() {
        return getAttributes().get("id").toString();
    }

    @Override
    @SuppressWarnings("unchecked")
    public String getName() {
        // 카카오에서 제공하는 'properties' 속성 중 'nickname' 추출
        Map<String, Object> properties = (Map<String, Object>) getAttributes().get("properties");
        if (properties == null) {
            return null;
        }
        return (String) properties.get("nickname");
    }

    @Override
    @SuppressWarnings("unchecked")
    public String getEmail() {
        // 카카오에서 제공하는 'kakao_account' 속성 중 'email' 추출
        Map<String, Object> kakaoAccount = (Map<String, Object>) getAttributes().get("kakao_account");
        if (kakaoAccount == null) {
            return null;
        }
        return (String) kakaoAccount.get("email");
    }

}