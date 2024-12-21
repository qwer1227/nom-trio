package store.seub2hu2.community.mapper;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;
import store.seub2hu2.community.vo.Board;
import store.seub2hu2.community.vo.Reply;

import java.util.List;

@Mapper
public interface ReplyMapper {

    void insertReply(@Param("reply") Reply reply);
    void insertComment(@Param("reply") Reply reply);
    List<Reply> getRepliesByTypeNo(@Param("no") int typeNo);
    Reply getReplyByReplyNo(@Param("no") int replyNo);
    int getReplyCntByTypeNo(@Param("no") int typeNo);
    void updateReply(@Param("reply") Reply reply);

    int hasUserLikedReply(@Param("rno") int replyNo, @Param("type") String type, @Param("userNo") int userNo);
    void insertReplyLike(@Param("no") int replyNo, @Param("type") String type, @Param("userNo") int userNo);
    void deleteReplyLike(@Param("rno") int replyNo, @Param("type") String type, @Param("userNo") int userNo);

    void updateCnt(@Param("reply") Reply reply);
}
