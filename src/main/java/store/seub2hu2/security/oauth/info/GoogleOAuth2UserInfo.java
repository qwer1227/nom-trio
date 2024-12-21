package store.seub2hu2.security.oauth.info;

import java.util.Map;

public class GoogleOAuth2UserInfo extends OAuth2UserInfo {

    public GoogleOAuth2UserInfo(Map<String, Object> attributes) {
        super(attributes);
    }

    @Override
    public String getId() {
        // Google에서 제공하는 'sub' 속성은 고유한 사용자 ID를 의미합니다.
        return (String) getAttributes().get("sub");
    }

    @Override
    public String getName() {
        // Google 사용자 이름
        return (String) getAttributes().get("name");
    }

    @Override
    public String getEmail() {
        // Google 사용자 이메일
        return (String) getAttributes().get("email");
    }

}