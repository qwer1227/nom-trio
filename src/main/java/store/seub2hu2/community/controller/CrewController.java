package store.seub2hu2.community.controller;

import lombok.RequiredArgsConstructor;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.core.io.ByteArrayResource;
import org.springframework.core.io.FileSystemResource;
import org.springframework.core.io.Resource;
import org.springframework.data.redis.core.RedisTemplate;
import org.springframework.http.HttpHeaders;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.stereotype.Controller;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.ui.Model;
import org.springframework.util.StringUtils;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.ModelAndView;
import store.seub2hu2.community.dto.CrewForm;
import store.seub2hu2.community.dto.ReplyForm;
import store.seub2hu2.community.dto.ReportForm;
import store.seub2hu2.community.service.CrewService;
import store.seub2hu2.community.service.LikeService;
import store.seub2hu2.community.service.ReplyService;
import store.seub2hu2.community.service.ReportService;
import store.seub2hu2.community.vo.Crew;
import store.seub2hu2.community.vo.CrewMember;
import store.seub2hu2.community.vo.Reply;
import store.seub2hu2.security.user.LoginUser;
import store.seub2hu2.util.ListDto;
import store.seub2hu2.util.RequestParamsDto;
import store.seub2hu2.util.S3Service;

import java.io.File;
import java.net.URLEncoder;
import java.time.Duration;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Controller
@RequestMapping("/community/crew")
@RequiredArgsConstructor
public class CrewController {

    private final RedisTemplate<String, String> redisTemplate;

    private final LikeService likeService;
    @Value("${upload.directory.crew.images}")
    private String imageSaveDirectory;

    @Value("${upload.directory.crew.files}")
    private String fileSaveDirectory;

    @Value("${cloud.aws.s3.bucket}")
    private String bucketName;

    private final S3Service s3Service;

    public final CrewService crewService;

    private final ReportService reportService;

    private final ReplyService replyService;

    @GetMapping("/main")
    public String list(@ModelAttribute("dto") RequestParamsDto dto
            , Model model) {

        ListDto<Crew> cDto = crewService.getCrews(dto);

        model.addAttribute("crews", cDto.getData());
        model.addAttribute("paging", cDto.getPaging());

        return "community/crew/main";
    }

    @GetMapping("/form")
    public String form() {
        return "community/crew/form";
    }

    @GetMapping("/detail")
    public String detail(@RequestParam("no") int crewNo
            , @AuthenticationPrincipal LoginUser loginUser
            , Model model) {
        Crew crew = crewService.getCrewDetail(crewNo);

        List<Reply> replyList = replyService.getReplies("crew", crewNo);
        crew.setReply(replyList);
        int replyCnt = replyService.getReplyCnt(crewNo);

        int memberCnt = crewService.getEnterMemberCnt(crewNo);

        model.addAttribute("crew", crew);
        model.addAttribute("replies", replyList);
        model.addAttribute("replyCnt", replyCnt);
        model.addAttribute("memberCnt", memberCnt);

        if (loginUser != null) {
            int crewResult = likeService.getCheckLike("crew", crewNo, loginUser);
            model.addAttribute("crewLiked", crewResult);

            boolean isExists = crewService.isExistCrewMember(crewNo, loginUser);
            model.addAttribute("isExists", isExists);

            for (Reply reply : replyList) {
                int replyResult = likeService.getCheckLike( "crewReply", reply.getNo(), loginUser);
                reply.setReplyLiked(replyResult);
            }
        }

        if (memberCnt < 5){
            crewService.updateCrewCondition(crewNo, "Y");
        } else {
            crewService.updateCrewCondition(crewNo, "N");
        }

        return "community/crew/detail";
    }

    @Transactional
    @GetMapping("/hit")
    public String hit(@RequestParam("no") int crewNo){
//        try{
//            String redisKey = "crew:viewCount" + crewNo;
//
//            // 남은 시간(초) 반환
//            System.out.println("TTL 설정 확인: " + redisTemplate.getExpire(redisKey));
//
//            // Redis에서 키가 존재하지 않으면 set
//            Boolean isFirstAccess = redisTemplate.opsForValue().setIfAbsent(redisKey, "30", Duration.ofMinutes(30));
//
//            if (Boolean.FALSE.equals(isFirstAccess)){
//                System.out.println("30분 내 조회수 업데이트 제한");
//                return "redirect:detail?no=" + crewNo;
//            }
//
//            redisTemplate.opsForValue().set(redisKey, "30", Duration.ofMinutes(30));
//            crewService.updateCrewViewCnt(crewNo);
//        } catch (Exception e){
//            e.printStackTrace();
//        }
        return "redirect:detail?no=" + crewNo;
    }

    @PostMapping("/register")
    @ResponseBody
    public Crew register(CrewForm form
            , @AuthenticationPrincipal LoginUser loginUser) {

        Crew crew = crewService.addNewCrew(form, loginUser);
        return crew;
    }

    @GetMapping("/modify")
    public String modifyForm(@RequestParam("no") int crewNo
            , @AuthenticationPrincipal LoginUser loginUser
            , Model model) {
        Crew crew = crewService.getCrewDetail(crewNo);
        model.addAttribute("crew", crew);

        return "community/crew/modify";
    }

    @PostMapping("/modify")
    @ResponseBody
    public Crew update(CrewForm form){

        Crew crew = crewService.updateCrew(form);
        return crew;
    }

    @GetMapping("/delete")
    public String delete(@RequestParam("no") int crewNo){
        CrewForm form = new CrewForm();
        form.setNo(crewNo);
        crewService.deleteCrew(crewNo);

        return "redirect:main";
    }

    @GetMapping("/delete-file")
    public String deleteFile(@RequestParam("no") int crewNo
            , @RequestParam("fileNo") int fileNo){

        crewService.deleteCrewFile(fileNo);
        return "redirect:modify?no=" + crewNo;
    }

    @GetMapping("/delete-thumbnail")
    public String deleteThumbnail(@RequestParam("no") int crewNo
            , @RequestParam("thumbnailNo") int thumbnailNo){

        crewService.deleteCrewFile(thumbnailNo);
        return "redirect:modify?no=" + crewNo;
    }

    @GetMapping("/filedown")
    public ResponseEntity<ByteArrayResource> download(@RequestParam("no") int crewNo) {

        Crew crew = crewService.getCrewDetail(crewNo);

        try {
            String originalFileName = crew.getUploadFile().getSaveName();
            String savedFilename = crew.getUploadFile().getSaveName();

            ByteArrayResource byteArrayResource = s3Service.downloadFile(bucketName, fileSaveDirectory, savedFilename);

            String encodedFileName = URLEncoder.encode(savedFilename.substring(13), "UTF-8");

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
    public String login(){
        return "redirect:../user/login";
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
            , @AuthenticationPrincipal LoginUser loginUser){

        Reply reply = replyService.addNewComment(form, loginUser);
        return reply;
    }

    @PostMapping("/modify-reply")
    @PreAuthorize("isAuthenticated()")
    public String modifyReply(ReplyForm form
            , @AuthenticationPrincipal LoginUser loginUser){

//        try{
        Reply reply = replyService.updateReply(form, loginUser);
//            return reply;
//        } catch (Exception e) {
//            e.printStackTrace();
//            return null;
//        }
        return "redirect:detail?no=" + reply.getTypeNo();
    }

    @GetMapping("/delete-reply")
    @PreAuthorize("isAuthenticated()")
    public String deleteReply(@RequestParam("rno") int replyNo,
                              @RequestParam("no") int crewNo){

        ReplyForm form = new ReplyForm();
        form.setNo(replyNo);
        form.setCrewNo(crewNo);
        replyService.deleteReply(replyNo);

        return "redirect:detail?no=" + crewNo;
    }

    @GetMapping("/update-crew-like")
    @PreAuthorize("isAuthenticated()")
    public String updateCrewLike(@RequestParam("no") int crewNo
            , @AuthenticationPrincipal LoginUser loginUser) {

        crewService.updateCrewLike(crewNo, loginUser);

        return "redirect:detail?no=" + crewNo;
    }

    @GetMapping("/delete-crew-like")
    @PreAuthorize("isAuthenticated()")
    public String updateCrewUnlike(@RequestParam("no") int crewNo
            , @AuthenticationPrincipal LoginUser loginUser) {

        crewService.deleteCrewLike(crewNo, loginUser);

        return "redirect:detail?no=" + crewNo;
    }

    @PostMapping("/update-reply-like")
    @PreAuthorize("isAuthenticated()")
    public String updateReplyLike(@RequestParam("no") int crewNo
            , @RequestParam("rno") int replyNo
            , @AuthenticationPrincipal LoginUser loginUser){

        replyService.updateReplyLike(replyNo,"crewReply", loginUser);
        return "redirect:detail?no=" + crewNo;
    }

    @PostMapping("/delete-reply-like")
    public String updateReplyUnlike(@RequestParam("no") int crewNo
            , @RequestParam("rno") int replyNo
            , @AuthenticationPrincipal LoginUser loginUser){

        replyService.deleteReplyLike(replyNo, "crewReply", loginUser);
        return "redirect:detail?no=" + crewNo;
    }

    @PostMapping("/report-crew")
    @PreAuthorize("isAuthenticated()")
    public String reportCrew(ReportForm form
            , @AuthenticationPrincipal LoginUser loginUser){
        boolean isReported = reportService.isReported(form.getType(), form.getNo(), loginUser);

        if (!isReported){
            reportService.registerReport(form, loginUser);
        }

        return "redirect:detail?no=" + form.getNo();
    }

    @PostMapping("report-reply")
    @PreAuthorize("isAuthenticated()")
    public String reportReply(ReportForm form
            , @AuthenticationPrincipal LoginUser loginUser){
        boolean isReported = reportService.isReported(form.getType(), form.getNo(), loginUser);

        if (!isReported){
            reportService.registerReport(form, loginUser);
        }

        Reply reply = replyService.getReplyDetail(form.getNo());
        return "redirect:detail?no=" + reply.getTypeNo();
    }

    @GetMapping("/enter-crew")
    public String enterCrew(@RequestParam("no") int crewNo
            , @AuthenticationPrincipal LoginUser loginUser){
        crewService.enterCrew(crewNo, loginUser);
        return "redirect:detail?no=" + crewNo;
    }

    @GetMapping("/leave-crew")
    public String leaveCrew(@RequestParam("no") int crewNo
            , @AuthenticationPrincipal LoginUser loginUser){
        crewService.leaveCrew(crewNo, loginUser);
        return "redirect:detail?no=" + crewNo;
    }

    @GetMapping("report-check")
    @ResponseBody
    public String reportCheck(@RequestParam("type") String type
            , @RequestParam("no") int no
            , @AuthenticationPrincipal LoginUser loginUser){

        boolean isReported = reportService.isReported(type, no, loginUser);

        return isReported ? "yes" : "no";
    }
}