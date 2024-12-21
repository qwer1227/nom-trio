package store.seub2hu2.order.exception;

// 특정 수량에 대해 재고가 부족할 때 예외를 발생시킨다. 예를 들어 사용자가 5개를 주문했는데 재고가 3개만 있을 경우, 이 예외를 던진다.
public class StockInsufficientException extends RuntimeException {

    public StockInsufficientException(String message) {
        super(message);
    }

    public StockInsufficientException(String message, Throwable cause) {
        super(message, cause);
    }
}
