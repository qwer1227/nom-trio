package store.seub2hu2.community.service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.stereotype.Service;
import store.seub2hu2.community.mapper.BoardMapper;
import store.seub2hu2.community.mapper.BoardScrapMapper;
import store.seub2hu2.community.vo.Board;
import store.seub2hu2.security.user.LoginUser;

@Service
public class ScrapService {

    @Autowired
    private BoardScrapMapper scrapMapper;

    @Autowired
    private BoardMapper boardMapper;

    public int getCheckScrap(int boardNo
            , @AuthenticationPrincipal LoginUser loginUser){
        return scrapMapper.hasUserScrapedBoard(boardNo, loginUser.getNo());
    }

    public void updateBoardScrap(int boardNo
            , @AuthenticationPrincipal LoginUser loginUser){
        scrapMapper.insertScrap(boardNo, loginUser.getNo());

        Board board = boardMapper.getBoardDetailByNo(boardNo);
        board.setScrapCnt((board.getScrapCnt() + 1));
        board.setLike(board.getLike());

        boardMapper.updateCnt(board);
    }

    public void deleteBoardScrap(int boardNo
            , @AuthenticationPrincipal LoginUser loginUser){
        scrapMapper.deleteScrap(boardNo, loginUser.getNo());

        Board board = boardMapper.getBoardDetailByNo(boardNo);
        board.setScrapCnt((board.getScrapCnt() - 1));
        board.setLike(board.getLike());

        boardMapper.updateCnt(board);
    }
}
