package store.seub2hu2.community.mapper;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;
import org.springframework.security.core.parameters.P;
import store.seub2hu2.community.vo.Board;

import java.util.List;
import java.util.Map;

@Mapper
public interface BoardMapper {

    void insertBoard(@Param("board") Board board);
    List<Board> getBoards(@Param("condition") Map<String, Object> condition);
    List<Board> getBoardsTopFive(@Param("condition") Map<String, Object> condition);
    int getTotalRowsForBoard(@Param("condition") Map<String, Object> condition);
    Board getBoardDetailByNo(@Param("no") int boardNo);
    void updateBoard(@Param("board") Board board); // 게시글 수정 및 삭제
    void updateBoardCnt(@Param("board") Board board); // 게시글 조회수 증가
    int getTotalRowsForHistory(@Param("condition") Map<String, Object> condition);
    int hasUserLikedBoard(@Param("no") int boardNo, @Param("type") String type, @Param("userNo") int userNo);
    void insertLike(@Param("no") int boardNo, @Param("type") String type, @Param("userNo") int userNo);
    void deleteLike(@Param("no") int boardNo, @Param("type") String type, @Param("userNo") int userNo);

    void updateCnt(@Param("board") Board board);
}
