package store.seub2hu2.community.controller;

import lombok.RequiredArgsConstructor;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.core.io.ByteArrayResource;
import org.springframework.core.io.FileSystemResource;
import org.springframework.core.io.Resource;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.util.StringUtils;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.ModelAndView;
import store.seub2hu2.community.dto.BoardForm;
import store.seub2hu2.community.dto.ReplyForm;
import store.seub2hu2.community.dto.ReportForm;
import store.seub2hu2.community.enums.BoardCategory;
import store.seub2hu2.community.service.*;
import store.seub2hu2.community.vo.*;
import store.seub2hu2.mypage.service.PostService;
import store.seub2hu2.security.user.LoginUser;
import store.seub2hu2.user.vo.User;
import store.seub2hu2.util.ListDto;
import store.seub2hu2.util.RequestParamsDto;
import store.seub2hu2.util.S3Service;

import java.io.File;
import java.net.URLEncoder;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Controller("communityController")
@RequestMapping("/community/board")
@RequiredArgsConstructor
public class BoardController {

    @Value("${upload.directory.board.files}")
    private String saveDirectory;

    @Value("${cloud.aws.s3.bucket}")
    private String bucketName;

    private final S3Service s3Service;

    public final BoardService boardService;

    public final ReplyService replyService;

    public final ScrapService scrapService;

    public final ReportService reportService;

    public final CrewService crewService;

    public final MarathonService marathonService;

    public final LikeService likeService;

    @GetMapping("/main")
    public String list(@ModelAttribute("dto") RequestParamsDto dto, Model model) {

        Map<String, Object> condition = new HashMap<>();

        ListDto<Board> bDto = boardService.getBoards(dto);
        ListDto<Notice> nDto = boardService.getNoticesTop(condition);
        ListDto<Crew> cDto = crewService.getCrewsTop(condition);
        ListDto<Marathon> mDto = marathonService.getMarathonTop(condition);

        model.addAttribute("boards", bDto.getData());
        model.addAttribute("paging", bDto.getPaging());
        model.addAttribute("notices", nDto.getData());
        model.addAttribute("crews", cDto.getData());
        model.addAttribute("marathons", mDto.getData());

        return "community/board/main";
    }

    @GetMapping("/detail")
    public String detail(@RequestParam("no") int boardNo
            , @AuthenticationPrincipal LoginUser loginUser
            , Model model) {
        Board board = boardService.getBoardDetail(boardNo);
        List<Reply> replyList = replyService.getReplies(boardNo);
        board.setReply(replyList);
        int replyCnt = replyService.getReplyCnt(boardNo);

        Map<String, Object> condition = new HashMap<>();
        ListDto<Board> dto = boardService.getBoardsTop(condition);
        model.addAttribute("boards", dto.getData());

        if (loginUser != null) {
            int boardResult = boardService.getCheckLike(boardNo, loginUser);
            model.addAttribute("boardLiked", boardResult);

            int scrapResult = scrapService.getCheckScrap(boardNo, loginUser);
            model.addAttribute("Scrapped", scrapResult);

            for (Reply reply : replyList) {
                int replyResult = likeService.getCheckLike("boardReply", reply.getNo(), loginUser);
                reply.setReplyLiked(replyResult);

                Reply prev = replyService.getReplyDetail(reply.getNo());
                reply.setPrevUser(prev.getPrevUser());
            }
        }

        model.addAttribute("board", board);
        model.addAttribute("replies", replyList);
        model.addAttribute("replyCnt", replyCnt);

        return "community/board/detail";
    }

    @GetMapping("/hit")
    public String hit(@RequestParam("no") int boardNo) {
        boardService.updateBoardViewCnt(boardNo);
        return "redirect:detail?no=" + boardNo;
    }

    @GetMapping("/form")
    @PreAuthorize("isAuthenticated()")
    public String form() {
        return "community/board/form";
    }

    @PostMapping("/register")
    @ResponseBody
    @PreAuthorize("isAuthenticated()")
    public Board register(BoardForm form
            , @AuthenticationPrincipal LoginUser loginUser) {

        Board board = boardService.addNewBoard(form, loginUser);
        return board;
    }

    @GetMapping("/modify")
    @PreAuthorize("isAuthenticated()")
    public String modifyForm(@RequestParam("no") int boardNo
            , Model model) {

        Board board = boardService.getBoardDetail(boardNo);
        model.addAttribute("board", board);

        return "community/board/modify";
    }

    @PostMapping("/modify")
    @ResponseBody
    @PreAuthorize("isAuthenticated()")
    public ResponseEntity<?> update(BoardForm form
            , @AuthenticationPrincipal LoginUser loginUser) {
        try {
            // 첨부파일이 없는 경우 처리
            if (form.getUpfile() != null && form.getUpfile().getName() == null) {
                form.setUpfile(null); // Null 처리
            }
            boardService.updateBoard(form, loginUser);
            return ResponseEntity.ok().body(form.getNo());
        } catch (Exception e) {
            // 예외 처리 및 로그 남기기
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body("글 수정 중 오류 발생: " + e.getMessage());
        }
    }

    @GetMapping("/delete")
    @PreAuthorize("isAuthenticated()")
    public String delete(@RequestParam("no") int boardNo) {

        BoardForm form = new BoardForm();
        form.setNo(boardNo);
        boardService.deleteBoard(boardNo);

        return "redirect:main";
    }

    @GetMapping("/delete-file")
    public String deleteUploadFile(@RequestParam("no") int boardNo
            , @RequestParam("fileNo") int fileNo) {

        boardService.deleteBoardFile(boardNo, fileNo);
        return "redirect:modify?no=" + boardNo;
    }

    // 요청 URL : comm/filedown?no=xxx
    @GetMapping("/filedown")
    public ResponseEntity<ByteArrayResource> download(@RequestParam("no") int boardNo) {

        Board board = boardService.getBoardDetail(boardNo);
        try {
            String filename = board.getUploadFile().getSaveName();
            ByteArrayResource byteArrayResource = s3Service.downloadFile(bucketName, saveDirectory, filename);

            String encodedFileName = URLEncoder.encode(filename.substring(13), "UTF-8");

            return ResponseEntity.ok()
                    .header(HttpHeaders.CONTENT_DISPOSITION, "attachment; filename=\"" + encodedFileName + "\"")
                    .contentType(MediaType.APPLICATION_OCTET_STREAM)
                    .contentLength(byteArrayResource.contentLength())
                    .body(byteArrayResource);
        } catch (Exception ex) {
            throw new RuntimeException(ex);
        }
    }

    @GetMapping("/login")
    public String login() {

        return "redirect:/user/login";
    }

    @PostMapping("/add-reply")
    @PreAuthorize("isAuthenticated()")
    @ResponseBody
    public Reply addReply(ReplyForm form
            , @AuthenticationPrincipal LoginUser loginUser) {

        Reply reply = replyService.addNewReply(form, loginUser);
        return reply;
    }

    @PostMapping("/add-comment")
    @PreAuthorize("isAuthenticated()")
    @ResponseBody
    public Reply addComment(ReplyForm form
            , @AuthenticationPrincipal LoginUser loginUser) {

        Reply reply = replyService.addNewComment(form, loginUser);
        return reply;
    }

    @PostMapping("/modify-reply")
    @PreAuthorize("isAuthenticated()")
    public String modifyReply(ReplyForm form
            , @AuthenticationPrincipal LoginUser loginUser) {

        replyService.updateReply(form, loginUser);
        return "redirect:detail?no=" + form.getTypeNo();
    }

    @GetMapping("/delete-reply")
    @PreAuthorize("isAuthenticated()")
    public String deleteReply(@RequestParam("rno") int replyNo,
                              @RequestParam("no") int boardNo) {

        ReplyForm form = new ReplyForm();
        form.setNo(replyNo);
        form.setTypeNo(boardNo);
        replyService.deleteReply(replyNo);

        return "redirect:detail?no=" + form.getTypeNo();
    }

    @GetMapping("/update-board-like")
    @PreAuthorize("isAuthenticated()")
    public String updateBoardLike(@RequestParam("no") int boardNo
            , @AuthenticationPrincipal LoginUser loginUser) {

        likeService.insertLike("board", boardNo, loginUser);
        return "redirect:detail?no=" + boardNo;
    }

    @GetMapping("/delete-board-like")
    @PreAuthorize("isAuthenticated()")
    public String updateBoardUnlike(@RequestParam("no") int boardNo
            , @AuthenticationPrincipal LoginUser loginUser) {

        likeService.deleteLike("board", boardNo, loginUser);
        return "redirect:detail?no=" + boardNo;
    }

    @PostMapping("/update-reply-like")
    @PreAuthorize("isAuthenticated()")
    public String updateReplyLike(@RequestParam("no") int boardNo
            , @RequestParam("rno") int replyNo
            , @AuthenticationPrincipal LoginUser loginUser) {

        likeService.insertLike("boardReply", replyNo, loginUser);
        return "redirect:detail?no=" + boardNo;
    }

    @PostMapping("/delete-reply-like")
    @PreAuthorize("isAuthenticated()")
    public String updateReplyUnlike(@RequestParam("no") int boardNo
            , @RequestParam("rno") int replyNo
            , @AuthenticationPrincipal LoginUser loginUser) {

        likeService.deleteLike("boardReply", replyNo, loginUser);
        return "redirect:detail?no=" + boardNo;
    }

    @GetMapping("/update-board-scrap")
    @PreAuthorize("isAuthenticated()")
    public String updateScrap(@RequestParam("no") int boardNo
            , @AuthenticationPrincipal LoginUser loginUser) {

        scrapService.updateBoardScrap(boardNo, loginUser);
        return "redirect:detail?no=" + boardNo;
    }

    @GetMapping("/delete-board-scrap")
    @PreAuthorize("isAuthenticated()")
    public String deleteScrap(@RequestParam("no") int boardNo
            , @AuthenticationPrincipal LoginUser loginUser) {

        scrapService.deleteBoardScrap(boardNo, loginUser);
        return "redirect:detail?no=" + boardNo;
    }

    @PostMapping("/report-board")
    @PreAuthorize("isAuthenticated()")
    public String reportBoard(ReportForm form
            , @AuthenticationPrincipal LoginUser loginUser) {
        boolean isReported = reportService.isReported(form.getType(), form.getNo(), loginUser);

        if (!isReported) {
            reportService.registerReport(form, loginUser);
        }

        return "redirect:detail?no=" + form.getNo();
    }

    @PostMapping("/report-reply")
    @PreAuthorize("isAuthenticated()")
    public String reportReply(ReportForm form
            , @AuthenticationPrincipal LoginUser loginUser) {
        boolean isReported = reportService.isReported(form.getType(), form.getNo(), loginUser);

        if (!isReported) {
            reportService.registerReport(form, loginUser);
        }

        Reply reply = replyService.getReplyDetail(form.getNo());
        return "redirect:detail?no=" + reply.getTypeNo();

    }

    @GetMapping("report-check")
    @ResponseBody
    @PreAuthorize("isAuthenticated()")
    public String reportCheck(@RequestParam("type") String type
            , @RequestParam("no") int no
            , @AuthenticationPrincipal LoginUser loginUser) {

        boolean isReported = reportService.isReported(type, no, loginUser);

        return isReported ? "yes" : "no";
    }
}
