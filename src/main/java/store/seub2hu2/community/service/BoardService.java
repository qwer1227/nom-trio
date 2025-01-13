package store.seub2hu2.community.service;

import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.multipart.MultipartFile;
import store.seub2hu2.community.dto.BoardForm;
import store.seub2hu2.community.dto.FunctionCheckDto;
import store.seub2hu2.community.enums.BoardCategory;
import store.seub2hu2.community.exception.CommunityException;
import store.seub2hu2.community.mapper.*;
import store.seub2hu2.community.vo.*;
import store.seub2hu2.security.user.LoginUser;
import store.seub2hu2.user.vo.User;
import store.seub2hu2.util.ListDto;
import store.seub2hu2.util.Pagination;
import store.seub2hu2.util.RequestParamsDto;
import store.seub2hu2.util.S3Service;

import java.util.List;
import java.util.Map;

@Slf4j
@Service
@Transactional
public class BoardService {

    @Value("${upload.directory.board.files}")
    private String saveDirectory;

    @Value("${cloud.aws.s3.bucket}")
    private String bucketName;

    @Autowired
    private S3Service s3Service;

    @Autowired
    private BoardMapper boardMapper;

    @Autowired
    private UploadMapper uploadMapper;

    @Autowired
    private ReplyMapper replyMapper;

    @Autowired
    private NoticeMapper noticeMapper;
    @Autowired
    private LikeService likeService;

    public Board addNewBoard(BoardForm form
            , @AuthenticationPrincipal LoginUser loginUser) {
        // Board 객체를 생성하여 사용자가 입력한 제목과 내용을 저장한다.
        Board board = new Board();
        board.setNo(form.getNo());
        board.setCategory(Integer.toString(form.getCatNo()));
        board.setTitle(form.getTitle());
        board.setContent(form.getContent());

        User user = new User();
        user.setNo(loginUser.getNo());
        user.setNickname(loginUser.getNickname());
        board.setUser(user);

        MultipartFile multipartFile = form.getUpfile();

        // 첨부파일이 있으면 실행
        if (multipartFile != null && !multipartFile.isEmpty()) {
            String originalFilename = multipartFile.getOriginalFilename();
            String filename = System.currentTimeMillis() + originalFilename;
            s3Service.uploadFile(multipartFile, bucketName, saveDirectory, filename);

            UploadFile uploadFile = new UploadFile();
            uploadFile.setOriginalName(originalFilename);
            uploadFile.setSaveName(filename);

            board.setUploadFile(uploadFile);
        }
        // board -> {no:0, ....}
        boardMapper.insertBoard(board);
        // board -> {no:34, }

        // 첨부파일이 있으면 실행
        // boardMapper.insertBoard()를 통해 board_no를 얻은 후에 실행해야 함
        if (multipartFile != null && !multipartFile.isEmpty()) {
            UploadFile uploadFile = board.getUploadFile();
            uploadFile.setNo(board.getNo());
            uploadFile.setSaveName(board.getUploadFile().getSaveName());
            uploadFile.setOriginalName(board.getOriginalFileName());
            // UploadFile 테이블에 저장
            uploadMapper.insertBoardFile(uploadFile);
        }

        return board;
    }

    public ListDto<Board> getBoards(RequestParamsDto dto) {
        // 검색 조건에 맞는 데이터 전체 갯수 조회
        int totalRows = boardMapper.getTotalRowsForBoard(dto);

        // pagination 객체 생성
        int page = dto.getPage();
        int rows = dto.getRows();
        Pagination pagination = new Pagination(page, totalRows, rows);

        //데이터 검색범위를 조회해서 Map에 저장
        dto.setBegin(pagination.getBegin());
        dto.setEnd(pagination.getEnd());

        // 조회범위에 맞는 데이터 조회하기
        List<Board> boards = boardMapper.getBoards(dto);
        ListDto<Board> bDto = new ListDto<>(boards, pagination);
        for (Board board : bDto.getData()) {
            board.setCategory(BoardCategory.getNameByCatNo(board.getCategory()));
        }

        return bDto;
    }

    public ListDto<Board> getHistoryBoards(RequestParamsDto requestParamsDto, int userNo) {
        // 검색 조건에 맞는 데이터 전체 갯수 조회
        int totalRows = boardMapper.getTotalRowsForHistory(requestParamsDto, userNo);


        // pagination 객체 생성
        int page = requestParamsDto.getPage();
        int rows = requestParamsDto.getRows();
        Pagination pagination = new Pagination(page, totalRows, rows);

        //데이터 검색범위를 조회해서 Map에 저장
        requestParamsDto.setBegin(pagination.getBegin());
        requestParamsDto.setEnd(pagination.getEnd());

        // 조회범위에 맞는 데이터 조회하기
        List<Board> boards = boardMapper.getBoards(requestParamsDto);
        ListDto<Board> dto = new ListDto<>(boards, pagination);

        return dto;
    }

    public ListDto<Board> getBoardsTop(Map<String, Object> condition) {
        List<Board> boards = boardMapper.getBoardsTopFive(condition);
        ListDto<Board> dto = new ListDto<>(boards);
        for (Board board : dto.getData()) {
            board.setCategory(BoardCategory.getNameByCatNo(board.getCategory()));
        }

        return dto;
    }

    public ListDto<Notice> getNoticesTop(Map<String, Object> condition) {
        List<Notice> notices = noticeMapper.getNoticesTopFive(condition);
        ListDto<Notice> dto = new ListDto<>(notices);

        return dto;
    }

    public Board getBoardDetail(int boardNo) {
        Board board = boardMapper.getBoardDetailByNo(boardNo);
        UploadFile uploadFile = uploadMapper.getFileByBoardNo(boardNo);

        FunctionCheckDto dto = new FunctionCheckDto();
        dto.setType("board");
        dto.setTypeNo(boardNo);

        List<Reply> reply = replyMapper.getRepliesByTypeNo(dto);

        if (board == null) {
            throw new CommunityException("존재하지 않는 게시글입니다.");
        }

        board.setUploadFile(uploadFile);
        board.setReply(reply);
        board.setCategory(BoardCategory.getNameByCatNo(board.getCategory()));

        User user = new User();
        user.setNo(board.getUser().getNo());
        user.setNickname(board.getUser().getNickname());
        board.setUser(user);

        return board;
    }

    public void updateBoardViewCnt(int boardNo) {
        Board board = boardMapper.getBoardDetailByNo(boardNo);
        board.setViewCnt(board.getViewCnt() + 1);
        boardMapper.updateBoardCnt(board);
    }

    public Board updateBoard(BoardForm form
            , @AuthenticationPrincipal LoginUser loginUser) {
        Board savedBoard = boardMapper.getBoardDetailByNo(form.getNo());
        savedBoard.setCategory(savedBoard.getCategory());
        savedBoard.setTitle(form.getTitle());
        savedBoard.setContent(form.getContent());

        User user = new User();
        user.setNo(loginUser.getNo());
        savedBoard.setUser(user);

        MultipartFile multipartFile = form.getUpfile();

        // 수정할 첨부파일이 있으면,
        if (multipartFile != null && !multipartFile.isEmpty()) {
            // 기존 파일 정보를 조회
            UploadFile prevFile = uploadMapper.getFileByBoardNo(savedBoard.getNo());
            // 기존 파일 정보가 존재하면 기존 파일 삭제
            if (prevFile != null) {
                prevFile.setDeleted("Y");
                uploadMapper.updateBoardFile(prevFile);
            }

            // 신규파일 정보를 조회하여 BOARD_UPLOADFILES 테이블에 저장
            String originalFilename = multipartFile.getOriginalFilename();
            String filename = System.currentTimeMillis() + originalFilename;
            s3Service.uploadFile(multipartFile, bucketName, saveDirectory, filename);

            UploadFile uploadFile = new UploadFile();
            uploadFile.setNo(savedBoard.getNo());
            uploadFile.setOriginalName(originalFilename);
            uploadFile.setSaveName(filename);
            savedBoard.setUploadFile(uploadFile);

            uploadMapper.insertBoardFile(uploadFile);
        }

        // 수정한 게시글 내용을 BOARDS 테이블에 저장
        boardMapper.updateBoard(savedBoard);

        return savedBoard;
    }

    public void deleteBoard(int boardNo) {
        Board savedBoard = boardMapper.getBoardDetailByNo(boardNo);
        savedBoard.setDeleted("Y");

        boardMapper.updateBoard(savedBoard);
    }

    public void deleteBoardFile(int boardNo, int fileNo) {
        UploadFile uploadFile = uploadMapper.getFileByBoardNo(boardNo);
        uploadFile.setFileNo(fileNo);
        uploadFile.setDeleted("Y");

        uploadMapper.updateBoardFile(uploadFile);
    }

    public int getCheckLike(int boardNo
            , @AuthenticationPrincipal LoginUser loginUser) {

        if (loginUser != null) {
            return boardMapper.hasUserLikedBoard(boardNo, "board", loginUser.getNo());
        } else {
            return 0;
        }
    }

    public void updateBoardLike(int boardNo
            , @AuthenticationPrincipal LoginUser loginUser) {
        likeService.insertLike("board", boardNo, loginUser);

        int cnt = likeService.getLikeCnt("board", boardNo);

        Board board = boardMapper.getBoardDetailByNo(boardNo);
        board.setLikeCnt(cnt);
        board.setScrapCnt(board.getScrapCnt());

        boardMapper.updateCnt(board);
    }

    public void deleteBoardLike(int boardNo
            , @AuthenticationPrincipal LoginUser loginUser) {
        likeService.deleteLike("board", boardNo, loginUser);

        int cnt = likeService.getLikeCnt("board", boardNo);

        Board board = boardMapper.getBoardDetailByNo(boardNo);
        board.setLikeCnt(cnt);
        board.setScrapCnt(board.getScrapCnt());

        boardMapper.updateCnt(board);
    }
}
