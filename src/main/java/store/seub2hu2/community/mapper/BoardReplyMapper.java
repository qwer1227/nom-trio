package store.seub2hu2.community.mapper;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;
import store.seub2hu2.community.vo.Reply;

import java.util.List;

@Mapper
public interface BoardReplyMapper {

    void updateReply(@Param("reply") Reply reply);
    void insertReply(@Param("reply") Reply reply);
    List<Reply> getRepliesByBoardNo(@Param("no") int boardNo);
    Reply getReplyByReplyNo(@Param("no") int replyNo);
    int getReplyCntByBoardNo(@Param("no") int boardNo);
    void deleteReplyByNo(@Param("no") int replyNo);

    int hasUserLikedReply(@Param("rno") int replyNo, @Param("userNo") int userNo);
    void insertReplyLike(@Param("rno") int replyNo, @Param("userNo") int userNo);
    void deleteReplyLike(@Param("rno") int replyNo, @Param("userNo") int userNo);
}
