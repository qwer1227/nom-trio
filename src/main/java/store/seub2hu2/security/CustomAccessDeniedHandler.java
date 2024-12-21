package store.seub2hu2.security;

import java.io.IOException;

import org.springframework.security.access.AccessDeniedException;
import org.springframework.security.web.access.AccessDeniedHandler;
import org.springframework.stereotype.Component;

import com.fasterxml.jackson.databind.ObjectMapper;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import store.seub2hu2.security.dto.RestResponseDto;

@Component
public class CustomAccessDeniedHandler implements AccessDeniedHandler {

    private static final ObjectMapper objectMapper = new ObjectMapper(); // ObjectMapper 재사용

    @Override
    public void handle(HttpServletRequest request, HttpServletResponse response,
                       AccessDeniedException accessDeniedException) throws IOException, ServletException {

        String requestURI = request.getRequestURI();

        // 권한이 없는 접근을 로깅 (추가)
        // 예를 들어, Slf4j 또는 Logback을 사용하여 접근을 로깅할 수 있음
        // log.info("Access denied for URI: {}", requestURI);

        if (requestURI.startsWith("/ajax")) {
            // 응답메세지객체를 생성한다.
            RestResponseDto<Void> dto = RestResponseDto.fail(HttpServletResponse.SC_FORBIDDEN, "접근권한이 없습니다.");

            // 응답메세지객체를 json 형식의 텍스트로 변환한다.
            String jsonText = objectMapper.writeValueAsString(dto);

            // HttpServletResponse 객체를 이용해서 응답을 보낸다.
            // 응답컨텐츠 타입을 지정한다.
            response.setContentType("application/json; charset=utf-8");
            // 응답메세지의 HTTP 응답코드를 403으로 설정한다.
            response.setStatus(HttpServletResponse.SC_FORBIDDEN);
            // 브라우저로 응답을 보낸다.
            response.getWriter().write(jsonText);
        } else {
            // 클라이언트가 접근할 수 없는 페이지를 요청하면 로그인 페이지로 리디렉션
            response.sendRedirect("/login?error=access-denied");
        }
    }
}

