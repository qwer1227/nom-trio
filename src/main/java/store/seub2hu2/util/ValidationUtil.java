package store.seub2hu2.util;

import java.util.Collection;
import java.util.HashSet;

public class ValidationUtil {

    // 중복 데이터 체크
    public static <T> void requireUnique(Collection<T> collection, String message) {
        if (collection.size() != new HashSet<>(collection).size()) {
            throw new IllegalArgumentException(message);
        }

    }
}
