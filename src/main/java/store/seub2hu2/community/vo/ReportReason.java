package store.seub2hu2.community.vo;

import lombok.Getter;

@Getter
public enum ReportReason {
    SPAM(1, "스팸홍보/도배글입니다."),
    ILLEGAL(2, "불법정보를 포함하고 있습니다."),
    PROFANITY(3, "욕설/생명경시/혐오/차별적 표현입니다."),
    PERSONAL(4, "개인정보 노출 게시물입니다."),
    UNPLEASANT(5, "불쾌한 표현이 있습니다."),
    ETC(6, "");

    private final String description;
    private final int reasonNo;

    ReportReason(int reasonNo, String description) {
        this.reasonNo = reasonNo;
        this.description = description;
    }

    public String getDescription(int reasonNo) {
        return description;
    }

    public static String getDescriptionByReasonNo(int reasonNo) {
        for (ReportReason reason : ReportReason.values()) {
            if (reason.reasonNo == reasonNo) {
                return reason.description;
            }
        }
        throw new IllegalArgumentException("Invalid reasonNo: " + reasonNo);
    }
}
