package store.seub2hu2.community.vo;

import lombok.Getter;

@Getter
public enum ReportReason {
    SPAM("스팸홍보/도배글입니다.", 1),
    ILLEGAL("불법정보를 포함하고 있습니다.", 2),
    PROFANITY("욕설/생명경시/혐오/차별적 표현입니다.", 3),
    PERSONAL("개인정보 노출 게시물입니다.", 4),
    UNPLEASANT("불쾌한 표현이 있습니다.", 5),
    ETC("", 6);

    private String reasonDetail;
    private int reasonNo;

    ReportReason(String reasonDetail, int reasonNo) {
        this.reasonDetail = reasonDetail;
        this.reasonNo = reasonNo;
    }
}
