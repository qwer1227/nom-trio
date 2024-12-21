package store.seub2hu2.community.service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.stereotype.Service;
import store.seub2hu2.community.dto.ReplyForm;
import store.seub2hu2.community.mapper.BoardReplyMapper;
import store.seub2hu2.community.vo.Reply;
import store.seub2hu2.security.user.LoginUser;
import store.seub2hu2.user.vo.User;

import java.util.List;

@Service
public class BoardReplyService {

    @Autowired
    private BoardReplyMapper boardReplyMapper;

    public void addNewReply(ReplyForm form
            , @AuthenticationPrincipal LoginUser loginUser) {
        Reply reply = new Reply();
        reply.setTypeNo(form.getTypeNo());
        reply.setContent(form.getContent());
        reply.setDeleted("N");

        User user = new User();
        user.setNo(loginUser.getNo());
        reply.setUser(user);

        boardReplyMapper.insertReply(reply);

        reply.setPrevNo(reply.getNo());
        reply.setDeleted(reply.getDeleted());
        reply.setUpdatedDate(null);
        boardReplyMapper.updateReply(reply);
    }

    public void addNewComment(ReplyForm form
            , @AuthenticationPrincipal LoginUser loginUser) {
        Reply reply = new Reply();
        reply.setTypeNo(form.getTypeNo());
        reply.setContent(form.getContent());
        reply.setDeleted("N");

        User user = new User();
        user.setNo(loginUser.getNo());
        reply.setUser(user);

        boardReplyMapper.insertReply(reply);

        reply.setPrevNo(form.getPrevNo());
        reply.setDeleted(reply.getDeleted());
        reply.setUpdatedDate(null);
        boardReplyMapper.updateReply(reply);
    }

    public List<Reply> getReplies(int boardNo) {
        List<Reply> replyList = boardReplyMapper.getRepliesByBoardNo(boardNo);

        return replyList;
    }

    public int getReplyCnt(int boardNo) {
        return boardReplyMapper.getReplyCntByBoardNo(boardNo);
    }

    public void deleteReply(int replyNo) {
        Reply reply = boardReplyMapper.getReplyByReplyNo(replyNo);
        reply.setTypeNo(reply.getNo());
        boardReplyMapper.deleteReplyByNo(replyNo);
    }

    public void updateReply(ReplyForm form) {
        Reply reply = boardReplyMapper.getReplyByReplyNo(form.getNo());
        reply.setContent(form.getContent());

        boardReplyMapper.updateReply(reply);
    }

    public int getCheckLike(int replyNo
                            , @AuthenticationPrincipal LoginUser loginUser) {

        return boardReplyMapper.hasUserLikedReply(replyNo, loginUser.getNo());
    }

    public void updateReplyLike(int replyNo
            , @AuthenticationPrincipal LoginUser loginUser) {

        boardReplyMapper.insertReplyLike(replyNo, loginUser.getNo());
    }

    public void deleteReplyLike(int replyNo
            , @AuthenticationPrincipal LoginUser loginUser) {
        boardReplyMapper.deleteReplyLike(replyNo, loginUser.getNo());
    }
}
