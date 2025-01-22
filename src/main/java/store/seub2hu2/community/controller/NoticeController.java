package store.seub2hu2.community.controller;

import lombok.RequiredArgsConstructor;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.core.io.ByteArrayResource;
import org.springframework.core.io.FileSystemResource;
import org.springframework.core.io.Resource;
import org.springframework.data.redis.core.RedisTemplate;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.stereotype.Controller;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.ui.Model;
import org.springframework.util.StringUtils;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.ModelAndView;
import store.seub2hu2.community.dto.NoticeForm;
import store.seub2hu2.community.service.NoticeService;
import store.seub2hu2.community.vo.Board;
import store.seub2hu2.community.vo.Notice;
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
@RequestMapping("/community/notice")
@RequiredArgsConstructor
public class NoticeController {

    private final RedisTemplate<String, String> redisTemplate;

    @Value("${upload.directory.notice.files}")
    private String saveDirectory;

    @Value("${cloud.aws.s3.bucket}")
    private String bucketName;

    private final S3Service s3Service;

    public final NoticeService noticeService;


    @GetMapping("/main")
    public String list(@ModelAttribute("dto") RequestParamsDto dto, Model model) {

        ListDto<Notice> nDto = noticeService.getNotices(dto);

        model.addAttribute("notices", nDto.getData());
        model.addAttribute("paging", nDto.getPaging());

        return "community/notice/main";
    }

    @GetMapping("/form")
    public String form() {
        return "community/notice/form";
    }

    @PostMapping("/register")
    @ResponseBody
    public Notice register(NoticeForm form) {
        Notice notice = noticeService.addNewNotice(form);
        return notice;
    }

    @GetMapping("/hit")
    public String hit(@RequestParam("no") int noticeNo) {
//        try{
//            String redisKey = "notice:viewCnt" + noticeNo;
//            // 남은 시간(초) 반환
//            System.out.println("TTL 설정 확인: " + redisTemplate.getExpire(redisKey));
//            // Redis에서 키가 존재하지 않으면 set
//            Boolean isFirstAccess = redisTemplate.opsForValue().setIfAbsent(redisKey, "30", Duration.ofMinutes(30));
//
//            if (Boolean.FALSE.equals(isFirstAccess)) {
//                System.out.println("30분 내 조회수 업데이트 제한");
//                return "redirect:detail?no=" + noticeNo;
//            }
//
//            redisTemplate.opsForValue().set(redisKey, "30", Duration.ofMinutes(30));
//            noticeService.updateNoticeViewCnt(noticeNo);
//        } catch (Exception e){
//            e.printStackTrace();
//        }
        return "redirect:detail?no=" + noticeNo;
    }

    @GetMapping("/detail")
    public String detail(@RequestParam("no") int noticeNo
            , Model model) {

        Notice notice = noticeService.getNoticeDetail(noticeNo);
        model.addAttribute("notice", notice);

        return "community/notice/detail";
    }

    @Transactional
    @GetMapping("/filedown")
    public ResponseEntity<ByteArrayResource> download(@RequestParam("no") int noticeNo) {

        Notice notice = noticeService.getNoticeDetail(noticeNo);

        try {
            String filename = notice.getUploadFile().getSaveName();
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

    @GetMapping("/modify")
    public String modifyForm(@RequestParam("no") int noticeNo, Model model) {
        Notice notice = noticeService.getNoticeDetail(noticeNo);
        model.addAttribute("notice", notice);
        return "community/notice/modify";
    }

    @PostMapping("/modify")
    @ResponseBody
    @PreAuthorize("isAuthenticated()")
    public ResponseEntity<?> update(NoticeForm form, @AuthenticationPrincipal LoginUser loginUser) {
        try {
            // 첨부파일이 없는 경우 처리
            if (form.getUpfile() != null && form.getUpfile().getName() == null) {
                form.setUpfile(null); // Null 처리
            }
            noticeService.updateNotice(form);

            String redirectUrl = "/community/notice/detail?no=" + form.getNo();

            return ResponseEntity.ok(redirectUrl);
        } catch (Exception e) {
            // 예외 처리 및 로그 남기기
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body("글 수정 중 오류 발생: " + e.getMessage());
        }
    }

    @GetMapping("/delete")
    public String delete(@RequestParam("no") int noticeNo) {
        noticeService.deleteNotice(noticeNo);
        return "redirect:main";
    }

    @GetMapping("/delete-file")
    public String deleteUploadFile(@RequestParam("no") int noticeNo
            , @RequestParam("fileNo") int fileNo){
        noticeService.deleteNoticeFile(noticeNo, fileNo);

        return "redirect:modify?no=" + noticeNo;
    }
}

