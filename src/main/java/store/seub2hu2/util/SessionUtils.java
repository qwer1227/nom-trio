package store.seub2hu2.util;

import jakarta.servlet.http.HttpSession;
import lombok.RequiredArgsConstructor;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;
import org.springframework.web.context.request.RequestAttributes;
import org.springframework.web.context.request.RequestContextHolder;

import java.util.Objects;

@Component
@RequiredArgsConstructor
public class SessionUtils {

    private final HttpSession session;

    public void addAttribute(String name, Object value) {
        session.setAttribute(name, value);
    }

    public <T> T getAttribute(String name) {
        return (T) session.getAttribute(name);
    }

    public void removeAttribute(String name) {
        session.removeAttribute(name);
    }

    public String getSessionId() {
        return session.getId();
    }

    public void invalidateSession() {
        session.invalidate();
    }
}
