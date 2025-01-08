package store.seub2hu2.community.vo;

import lombok.Getter;

import java.util.Arrays;
import java.util.List;
import java.util.stream.Collectors;

public enum BoardCategory {

    NORMAL(100, "일반게시판")
    , PRIDE(110, "자랑게시판")
    , QUESTION(120, "질문게시판")
    , TRAINING_LOG(130, "훈련일지");

    private String name;
    private int catNo;

    BoardCategory(int catNo, String name) {
        this.catNo = catNo;
        this.name = name;
    }

    public int getCatNo() {
        return catNo;
    }

    public String getName(int catNo) {
        return name;
    }

//    // 모든 카테고리 이름을 반환하는 메소드
//    public static List<String> getCategoryNames(){
//        return Arrays.stream(BoardCategory.values())
//                .map(BoardCategory::getStatus)
//                .collect(Collectors.toUnmodifiableList());
//    }
}

