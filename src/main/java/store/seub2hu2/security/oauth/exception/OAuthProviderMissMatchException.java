package store.seub2hu2.security.oauth.exception;

import java.io.Serial;

public class OAuthProviderMissMatchException extends RuntimeException {

    @Serial
    private static final long serialVersionUID = -6225999273740936651L;

    public OAuthProviderMissMatchException(String message) {
        super(message);
    }
}