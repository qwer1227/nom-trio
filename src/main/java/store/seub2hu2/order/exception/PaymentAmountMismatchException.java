package store.seub2hu2.order.exception;

public class PaymentAmountMismatchException extends RuntimeException {

    public PaymentAmountMismatchException(String message) {
        super(message);
    }

    public PaymentAmountMismatchException(String message, Throwable cause) {
        super(message, cause);
    }
}
