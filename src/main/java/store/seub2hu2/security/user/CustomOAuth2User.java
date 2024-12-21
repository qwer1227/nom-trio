package store.seub2hu2.security.user;

import org.springframework.security.core.GrantedAuthority;
import org.springframework.security.core.authority.SimpleGrantedAuthority;
import org.springframework.security.oauth2.core.user.OAuth2User;
import store.seub2hu2.user.vo.Role;
import store.seub2hu2.user.vo.User;

import java.util.Collection;
import java.util.Collections;
import java.util.Map;

public class CustomOAuth2User extends LoginUser implements OAuth2User {

    private String provider;
    private Collection<GrantedAuthority> authorities;
    private Map<String, Object> attributes;

    public CustomOAuth2User(User user, Role role, Map<String, Object> attributes) {
        super(user);
        this.provider = user.getProvider();
        this.authorities = Collections.singletonList(new SimpleGrantedAuthority(role.getName()));
        this.attributes = attributes;
    }

    @Override
    public Map<String, Object> getAttributes() {
        return attributes;
    }

    @Override
    public Collection<? extends GrantedAuthority> getAuthorities() {
        return authorities;
    }

    @Override
    public String getName() {
        return getId();
    }

    public String getProvider() {
        return provider;
    }
}