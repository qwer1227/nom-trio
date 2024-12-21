package store.seub2hu2.community.service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.stereotype.Service;
import store.seub2hu2.community.dto.ReplyForm;
import store.seub2hu2.community.mapper.BoardReplyMapper;
import store.seub2hu2.community.mapper.CrewReplyMapper;
import store.seub2hu2.community.vo.Reply;
import store.seub2hu2.security.user.LoginUser;
import store.seub2hu2.user.vo.User;

import java.util.List;

@Service
public class CrewReplyService {

    @Autowired
    private CrewReplyMapper crewReplyMapper;

    public void addNewReply(ReplyForm form
            , @AuthenticationPrincipal LoginUser loginUser) {
        Reply reply = new Reply();
        reply.setCrewNo(form.getCrewNo());
        reply.setContent(form.getContent());
        reply.setDeleted("N");

        User user = new User();
        user.setNo(loginUser.getNo());
        reply.setUser(user);

        crewReplyMapper.insertReply(reply);

        reply.setPrevNo(reply.getNo());
        reply.setDeleted(reply.getDeleted());
        reply.setUpdatedDate(null);
        crewReplyMapper.updateReply(reply);
    }

    public void addNewComment(ReplyForm form
            , @AuthenticationPrincipal LoginUser loginUser) {
        Reply reply = new Reply();
        reply.setCrewNo(form.getCrewNo());
        reply.setContent(form.getContent());
        reply.setDeleted("N");

        User user = new User();
        user.setNo(loginUser.getNo());
        reply.setUser(user);

        crewReplyMapper.insertReply(reply);

        reply.setPrevNo(form.getPrevNo());
        reply.setDeleted(reply.getDeleted());
        reply.setUpdatedDate(null);
        crewReplyMapper.updateReply(reply);
    }

    public List<Reply> getReplies(int crewNo) {
        List<Reply> replyList = crewReplyMapper.getRepliesByCrewNo(crewNo);

        return replyList;
    }

    public int getReplyCnt(int crewNo) {
        return crewReplyMapper.getReplyCntByCrewNo(crewNo);
    }

    public void deleteReply(int replyNo) {
        Reply reply = crewReplyMapper.getReplyByReplyNo(replyNo);
        reply.setCrewNo(reply.getCrewNo());
        crewReplyMapper.deleteReplyByNo(replyNo);
    }

    public void updateReply(ReplyForm form) {
        Reply reply = crewReplyMapper.getReplyByReplyNo(form.getNo());
        reply.setContent(form.getContent());

        crewReplyMapper.updateReply(reply);
    }

    public int getCheckLike(int replyNo
                            , @AuthenticationPrincipal LoginUser loginUser) {

        if (loginUser != null) {
            return crewReplyMapper.hasUserLikedReply(replyNo, loginUser.getNo());
        } else {
            return 0;
        }

    }

    public void updateReplyLike(int replyNo
            , @AuthenticationPrincipal LoginUser loginUser) {

        crewReplyMapper.insertReplyLike(replyNo, loginUser.getNo());
    }

    public void deleteReplyLike(int replyNo
            , @AuthenticationPrincipal LoginUser loginUser) {
        crewReplyMapper.deleteReplyLike(replyNo, loginUser.getNo());
    }
}
