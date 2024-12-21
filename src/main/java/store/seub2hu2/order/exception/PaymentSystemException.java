package store.seub2hu2.order.exception;

// 결제 예외
public class PaymentSystemException extends RuntimeException{

    public PaymentSystemException(String message) {
        super(message);
    }
    
    public PaymentSystemException(String message, Throwable cause) {
        super(message, cause);
    }
}
