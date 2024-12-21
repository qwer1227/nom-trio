package store.seub2hu2.security;

import java.io.IOException;

import org.springframework.security.core.AuthenticationException;
import org.springframework.security.web.AuthenticationEntryPoint;
import org.springframework.stereotype.Component;

import store.seub2hu2.security.dto.RestResponseDto;
import com.fasterxml.jackson.databind.ObjectMapper;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@Component
public class CustomAuthenticationEntryPoint
        implements AuthenticationEntryPoint {

    // 인증되지 않은 사용자가 인증이 필요한 서비스를 요청했을 때 실행되는 메소드다.
    @Override
    public void commence(HttpServletRequest request, HttpServletResponse response,
                         AuthenticationException authException) throws IOException, ServletException {

        String requestURI = request.getRequestURI();

        if (requestURI.startsWith("/ajax")) {
            // 응답메세지객체를 생성한다.
            RestResponseDto<Void> dto
                    = RestResponseDto.fail(HttpServletResponse.SC_UNAUTHORIZED, "로그인이 필요한 서비스입니다");

            // 응답메세지객체를 json 형식의 텍스트로 변환한다.
            ObjectMapper objectMapper = new ObjectMapper();
            String jsonText = objectMapper.writeValueAsString(dto);

            // HttpServletResponse 객체를 이용해서 응답을 보낸다.
            // 응답컨텐츠 타입을 지정한다.
            response.setContentType("application/json; charset=utf-8");
            // 응답메세지의 HTTP 응답코드를 401로 설정한다.
            response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
            // 브라우저로 응답을 보낸다.
            response.getWriter().write(jsonText);
        } else {
            response.sendRedirect("/login?error=required");
        }

    }
}
