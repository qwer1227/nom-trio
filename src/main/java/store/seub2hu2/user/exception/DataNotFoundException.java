package store.seub2hu2.user.exception;

public class DataNotFoundException extends StoreException  {
    public DataNotFoundException(String message) {
        super(message);
    }

    public DataNotFoundException(String message, Throwable cause) {
        super(message, cause);
    }
}
