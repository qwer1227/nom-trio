package store.seub2hu2.lesson.enums;

public enum ReservationStatus {
    RESERVATION("예약", 1),
    COMPLETED("수강종료", 2),
    CANCELLED("취소", 3);

    private final String label;
    private final int value;

    ReservationStatus(String label, int value) {
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
