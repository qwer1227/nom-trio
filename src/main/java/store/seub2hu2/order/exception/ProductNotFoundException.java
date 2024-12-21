package store.seub2hu2.order.exception;

// 상품이 없을 때 발생하는 예외
public class ProductNotFoundException extends RuntimeException {

    public ProductNotFoundException(String message) {
        super(message);
    }
    
    public ProductNotFoundException(String message, Throwable cause) {
        super(message, cause);
    }
}
