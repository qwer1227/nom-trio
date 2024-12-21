package store.seub2hu2.mypage.enums;

import lombok.*;

@AllArgsConstructor
@ToString
@Getter
public enum QnaStatus {
    대기("대기",0),    // 대기
    완료("완료",1),  // 완료
    삭제("삭제",2);    // 삭제

    private final int code;
    private final String value;

    QnaStatus(String value, int code){
        this.value = value;
        this.code = code;
    }

    public int getCode() {
        return code;
    }

    public String getValue() {
        return value;
    }

    public static QnaStatus fromCode(int code) {
        for (QnaStatus status : QnaStatus.values()) {
            if (status.getCode() == code) {
                return status;
            }
        }
        throw new IllegalArgumentException("Invalid code: " + code);
    }

}
