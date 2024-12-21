package store.seub2hu2.order.exception;

// 데이터 베이스 저장 실패 예외
public class DatabaseSaveException extends RuntimeException{

    public DatabaseSaveException(String message) {
        super(message);
    }

    public DatabaseSaveException(String message, Throwable cause) {
        super(message, cause);
    }
}
