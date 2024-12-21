package store.seub2hu2.lesson.enums;


public enum LessonCategory {
    POSTURE("자세", 1),
    BREATH("호흡", 2),
    EXERCISE( "운동", 3);

    private final String label;
    private final int value;

    LessonCategory(String label, int value) {
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
