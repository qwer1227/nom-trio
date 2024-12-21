package store.seub2hu2.lesson.enums;

import lombok.Getter;

@Getter
public enum LessonStatus {
    RECRUITMENT("모집중", 1),
    CLOSE("마감", 2),
    CANCEL("취소", 3);

    private final String label;
    private final int value;

    LessonStatus(String label, int value) {
        this.label = label;
        this.value = value;
    }

    public String label() {
        return label;
    }

    public int value() {
        return value;
    }
}
