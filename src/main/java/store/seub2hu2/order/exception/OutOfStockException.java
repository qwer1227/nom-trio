package store.seub2hu2.order.exception;

// 재고 부족 예외
public class OutOfStockException extends RuntimeException {

    public OutOfStockException(String message) {
        super(message);
    }
    
    public OutOfStockException(String message, Throwable cause) {
        super(message, cause);
    }
}
