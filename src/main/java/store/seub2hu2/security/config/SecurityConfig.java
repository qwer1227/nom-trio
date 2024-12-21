package store.seub2hu2.security.config;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.security.authentication.AuthenticationManager;
import org.springframework.security.config.annotation.authentication.configuration.AuthenticationConfiguration;
import org.springframework.security.config.annotation.method.configuration.EnableMethodSecurity;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.config.annotation.web.configuration.EnableWebSecurity;
import org.springframework.security.config.http.SessionCreationPolicy;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.security.web.SecurityFilterChain;
import org.springframework.security.web.header.writers.frameoptions.XFrameOptionsHeaderWriter;
import org.springframework.web.cors.CorsConfiguration;
import org.springframework.web.cors.CorsConfigurationSource;
import org.springframework.web.cors.UrlBasedCorsConfigurationSource;
import org.springframework.web.servlet.config.annotation.CorsRegistry;
import org.springframework.web.servlet.config.annotation.WebMvcConfigurer;
import store.seub2hu2.security.CustomAccessDeniedHandler;
import store.seub2hu2.security.CustomAuthenticationEntryPoint;
import store.seub2hu2.security.service.CustomOAuth2UserService;

import java.util.List;

@Configuration
@EnableWebSecurity
@EnableMethodSecurity(prePostEnabled = true, securedEnabled = true)
public class SecurityConfig {

    @Autowired
    private CustomAuthenticationEntryPoint customAuthenticationEntryPoint;

    @Autowired
    private CustomAccessDeniedHandler customAccessDeniedHandler;

    @Autowired
    private CustomOAuth2UserService customOAuth2UserService;

    @Autowired
    private AuthenticationConfiguration authenticationConfiguration;

    // AuthenticationManager 빈 등록
    @Bean
    public AuthenticationManager authenticationManager() throws Exception {
        return authenticationConfiguration.getAuthenticationManager();
    }

    // 스마트 에디터 적용 코드
    @Bean
    public CorsConfigurationSource corsConfigurationSource() {
        CorsConfiguration configuration = new CorsConfiguration();
        configuration.setAllowedOriginPatterns(List.of("*")); // 모든 도메인 허용
        configuration.setAllowedMethods(List.of("GET", "POST", "PUT", "DELETE", "OPTIONS"));
        configuration.setAllowedHeaders(List.of("*")); // 모든 헤더 허용
        configuration.setAllowCredentials(true); // 인증 정보를 포함할 수 있도록 설정

        UrlBasedCorsConfigurationSource source = new UrlBasedCorsConfigurationSource();
        source.registerCorsConfiguration("/**", configuration);
        return source;
    }

    @Bean
    public SecurityFilterChain apiSecurityFilterChain(HttpSecurity http) throws Exception {
        http
                // 스마트 에디터 적용
                .headers((headers) -> headers
                        .addHeaderWriter(new XFrameOptionsHeaderWriter(XFrameOptionsHeaderWriter.XFrameOptionsMode.SAMEORIGIN)))
                .securityMatcher("/api/**")  // REST API에만 적용
                .csrf(csrf -> csrf.disable()) // CSRF 비활성화
                .authorizeHttpRequests(auth -> auth
                        .requestMatchers("/auth/**").permitAll() // /auth/** 경로 허용
                        // static 이하 /js/**, /css/**, /image/** 경로는 인증 없이 접근 가능
                        .requestMatchers("/js/**", "/css/**", "/image/**").permitAll()
                        .anyRequest().permitAll()) // 모든 API 요청은 인증 필요
                .sessionManagement(session -> session
                        .sessionCreationPolicy(SessionCreationPolicy.STATELESS)); // 세션 사용 안 함

        return http.build();
    }

    @Bean
    SecurityFilterChain webSecurityFilterChain(HttpSecurity http) throws Exception {

// 세션 기반 일반 로그인 설정
        http
                .headers((headers) -> headers
                        .addHeaderWriter(new XFrameOptionsHeaderWriter(XFrameOptionsHeaderWriter.XFrameOptionsMode.SAMEORIGIN)))
                .csrf(csrf -> csrf.disable()) // CSRF 활성화
                // 접근 인가정책을 설정한다.
                .authorizeHttpRequests(auth -> auth
                        // /mypage** 요청은 USER, MANAGER, ADMIN 권한을 가지고 있을 때만 접근허용
//                        .requestMatchers("/mypage/**").hasAnyRole("USER", "COACH", "ADMIN")
                        // /admin/** 요청은 ADMIN 권한을 가지고 있을때만 접근허용
                        .requestMatchers("/admin/**").hasRole("ADMIN")
                        // 위에서 설정한 요청외의 모든 요청은 인증된 사용자만 접근허용
                        .anyRequest().permitAll())
                // 폼 로그인 정책을 설정한다.
                .formLogin(formLogin -> formLogin
                        // 로그인 폼을 요청하는 URL을 지정한다.
                        .loginPage("/login")
                        // 로그인 폼의 입력필드 이름을 지정한다.
                        .usernameParameter("id")
                        .passwordParameter("password")
                        // 로그인 요청을 처리하는 url을 지정한다.
                        .loginProcessingUrl("/login")
                        // 로그인 성공 시 이동할 URL을 지정한다.
                        .defaultSuccessUrl("/home")
                        // 로그인 실패 시 이동할 URL을 지정한다.
                        .failureUrl("/login?error=fail"))
// 로그아웃 정책을 설정한다.
                .logout(logout -> logout
// 로그아웃...
                        .logoutUrl("/logout")
                        .logoutSuccessUrl("/home")
                        .invalidateHttpSession(true))
                .oauth2Login(oauth2Configurer -> oauth2Configurer
                        .loginPage("/login")
                        .defaultSuccessUrl("/home") // 소셜 로그인 성공 후 /user/social-join-form 페이지로 리다이렉트
                        .failureUrl("/login?error=fail")
                        .userInfoEndpoint(userEndpoint -> userEndpoint.userService(customOAuth2UserService)))
                .exceptionHandling(exceptionHandling -> exceptionHandling
                        // 인증되지 않은 사용자가 인증이 필요한 리소스를 요청했을 때
                        .authenticationEntryPoint(customAuthenticationEntryPoint)
                        // 접근권한을 가지고 있지 않는 리소스를 요청했을 때
                        .accessDeniedHandler(customAccessDeniedHandler));

        return http.build();
    }

    @Bean
    PasswordEncoder passwordEncoder() {
        return new BCryptPasswordEncoder();
    }


}
