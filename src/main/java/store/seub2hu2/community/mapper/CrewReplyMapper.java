package store.seub2hu2.community.mapper;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;
import store.seub2hu2.community.vo.Crew;
import store.seub2hu2.community.vo.Reply;

import java.util.List;

@Mapper
public interface CrewReplyMapper {

    void updateReply(@Param("reply") Reply reply);
    void insertReply(@Param("reply") Reply reply);
    List<Reply> getRepliesByCrewNo(@Param("no") int crewNo);
    Reply getReplyByReplyNo(@Param("no") int replyNo);
    int getReplyCntByCrewNo(@Param("no") int crewNo);
    void deleteReplyByNo(@Param("no") int replyNo);

    int hasUserLikedReply(@Param("rno") int replyNo, @Param("userNo") int userNo);
    void insertReplyLike(@Param("rno") int replyNo, @Param("userNo") int userNo);
    void deleteReplyLike(@Param("rno") int replyNo, @Param("userNo") int userNo);
}
