package store.seub2hu2.community.service;

import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import store.seub2hu2.community.dto.ReplyForm;
import store.seub2hu2.community.mapper.ReplyMapper;
import store.seub2hu2.community.vo.Reply;
import store.seub2hu2.security.user.LoginUser;
import store.seub2hu2.user.service.UserService;
import store.seub2hu2.user.vo.User;

import java.util.List;

@Slf4j
@Service
@Transactional
public class ReplyService {

    @Autowired
    private ReplyMapper replyMapper;

    public Reply addNewReply(ReplyForm form
            , @AuthenticationPrincipal LoginUser loginUser) {
        Reply reply = new Reply();
        reply.setType(form.getType());
        reply.setTypeNo(form.getTypeNo());
        reply.setContent(form.getContent());

        User user = new User();
        user.setNo(loginUser.getNo());
        user.setNickname(loginUser.getNickname());
        reply.setUser(user);

        replyMapper.insertReply(reply);

        reply.setPrevNo(reply.getNo());
        reply.setContent(reply.getContent());
        reply.setDeleted("N");
        reply.setUpdatedDate(null);

        replyMapper.updateReply(reply);

        return reply;
    }

    public Reply addNewComment(ReplyForm form
            , @AuthenticationPrincipal LoginUser loginUser) {
        Reply reply = new Reply();
        reply.setPrevNo(form.getPrevNo());
        reply.setType(form.getType());
        reply.setTypeNo(form.getTypeNo());
        reply.setContent(form.getContent());

        User user = new User();
        user.setNo(loginUser.getNo());
        user.setNickname(loginUser.getNickname());
        reply.setUser(user);

        replyMapper.insertComment(reply);

        return reply;
    }

    public Reply getReplyDetail(int replyNo){
        Reply reply = replyMapper.getReplyByReplyNo(replyNo);

        return reply;
    }

    public List<Reply> getReplies(int typeNo) {
        List<Reply> replyList = replyMapper.getRepliesByTypeNo(typeNo);

        return replyList;
    }

    public int getReplyCnt(int typeNo) {
        return replyMapper.getReplyCntByTypeNo(typeNo);
    }

    public Reply updateReply(ReplyForm form
            , @AuthenticationPrincipal LoginUser loginUser) {
        Reply reply = replyMapper.getReplyByReplyNo(form.getNo());

        reply.setNo(form.getNo());
        reply.setType(form.getType());
        reply.setTypeNo(form.getTypeNo());
        reply.setContent(form.getContent());
        reply.setDeleted("N");

        User user = new User();
        user.setNo(loginUser.getNo());
        reply.setUser(user);

        if (loginUser.getNo() == reply.getUser().getNo()) {
            replyMapper.updateReply(reply);
        }

        return reply;
    }

    public void deleteReply(int replyNo) {
        Reply reply = replyMapper.getReplyByReplyNo(replyNo);
        reply.setDeleted("Y");
        replyMapper.updateReply(reply);
    }

    public int getCheckLike(int replyNo
            , String type
            , @AuthenticationPrincipal LoginUser loginUser) {
        if (loginUser != null) {
            return replyMapper.hasUserLikedReply(replyNo, type, loginUser.getNo());
        } else {
            return 0;
        }
    }

    public void updateReplyLike(int replyNo
            , String type
            , @AuthenticationPrincipal LoginUser loginUser) {
        replyMapper.insertReplyLike(replyNo, type, loginUser.getNo());

        Reply reply = replyMapper.getReplyByReplyNo(replyNo);
        reply.setReplyLikeCnt(reply.getReplyLikeCnt() + 1);
        replyMapper.updateCnt(reply);
    }

    public void deleteReplyLike(int replyNo
            , String type
            , @AuthenticationPrincipal LoginUser loginUser) {
        replyMapper.deleteReplyLike(replyNo, type, loginUser.getNo());

        Reply reply = replyMapper.getReplyByReplyNo(replyNo);
        reply.setReplyLikeCnt(reply.getReplyLikeCnt() - 1);
        replyMapper.updateCnt(reply);
    }
}
