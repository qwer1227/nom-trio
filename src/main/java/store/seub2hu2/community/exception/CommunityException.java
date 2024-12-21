package store.seub2hu2.community.exception;

public class CommunityException extends RuntimeException {

    public CommunityException(String message) {
        super(message);
    }

    public CommunityException(String message, Throwable cause) {
        super(message, cause);
    }
}
