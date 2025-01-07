package store.seub2hu2.community.vo;

import lombok.Getter;

import java.util.Arrays;
import java.util.List;
import java.util.stream.Collectors;

@Getter
public enum BoardCategory {

    NORMAL("일반게시판", 100)
    , PRIDE("자랑게시판", 110)
    , QUESTION("질문게시판", 120)
    , TRAINING_LOG("훈련일지", 130);

    private String name;
    private int catNo;

    BoardCategory(String name, int catNo) {
        this.name = name;
        this.catNo = catNo;
    }

    private int getCatNo(int catNo) {
        return catNo;
    }

    private String getCatName(String name) {
        return name;
    }

//    // 모든 카테고리 이름을 반환하는 메소드
//    public static List<String> getCategoryNames(){
//        return Arrays.stream(BoardCategory.values())
//                .map(BoardCategory::getStatus)
//                .collect(Collectors.toUnmodifiableList());
//    }
}

