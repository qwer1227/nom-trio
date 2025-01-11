package store.seub2hu2.community.enums;

import lombok.Getter;

@Getter
public enum BoardCategory {

    NORMAL(100, "일반게시판"),
    PRIDE(110, "자랑게시판"),
    QUESTION(120, "질문게시판"),
    TRAINING_LOG(130, "훈련일지");

    private int no;
    private String name;

    BoardCategory(int no, String name) {
        this.no = no;
        this.name = name;
    }

    //    // 모든 카테고리 이름을 반환하는 메소드
    public static String getNameByCatNo(String no) {
        for (BoardCategory category : BoardCategory.values()) {
            if (Integer.toString(category.getNo()).equals(no)) {
                return category.getName();
            }
        }
        throw new IllegalArgumentException("Invalid no: " + no);
    }

}

