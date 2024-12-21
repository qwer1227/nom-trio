package store.seub2hu2.community.mapper;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;
import store.seub2hu2.community.vo.Board;

@Mapper
public interface BoardScrapMapper {

    int hasUserScrapedBoard(@Param("no") int boardNo, @Param("userNo") int userNo);
    void insertScrap(@Param("no") int boardNo, @Param("userNo") int userNo);
    void deleteScrap(@Param("no") int boardNo, @Param("userNo") int userNo);

}
