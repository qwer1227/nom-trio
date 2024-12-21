package store.seub2hu2.security.dto;

import jakarta.servlet.http.HttpServletResponse;
import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class  RestResponseDto<T> {

    private int status;
    private String message;
    private T data;

    /**
     * 요청처리를 성공했을 때 응답을 생성해서 반환한다.
     * @param <T> 데이터의 타입
     * @param data 응답으로 보내는 데이터
     * @return Rest 표준 응답객체
     */
    public static <T> RestResponseDto<T> success(T data) {
        RestResponseDto<T> dto = new RestResponseDto<>();
        dto.setStatus(HttpServletResponse.SC_OK);
        dto.setMessage("성공");
        dto.setData(data);

        return dto;
    }

    /**
     * 요청처리를 실패했을 때 응답을 생성해서 반환한다.
     * @param <T> 데이터 타입, 데이터가 없기 때문에 Void 로 설정한다.
     * @param message 오류 메세지
     * @return Rest 표준 응답객체
     */
    public static <T> RestResponseDto<T> fail(String message) {
        RestResponseDto<T> dto = new RestResponseDto<>();
        dto.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
        dto.setMessage(message);
        dto.setData(null);

        return dto;
    }

    /**
     * 요청처리를 실패했을 때 응답을 생성해서 반환한다.
     * @param <T> 데이터 타입, 데이터가 없기 때문에 Void 로 설정한다.
     * @param status HTTP 응답 코드(오류내용을 설명하는 응답코드)
     * @param message 오류 메세지
     * @return Rest 표준 응답객체
     */
    public static <T> RestResponseDto<T> fail(int status, String message) {
        RestResponseDto<T> dto = new RestResponseDto<>();
        dto.setStatus(status);
        dto.setMessage(message);
        dto.setData(null);

        return dto;
    }
}








