package store.seub2hu2.admin.controller;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.util.StringUtils;
import org.springframework.web.bind.annotation.*;
import store.seub2hu2.admin.dto.ReportDto;
import store.seub2hu2.admin.dto.RequestParamsDto;
import store.seub2hu2.admin.service.AdminService;
import store.seub2hu2.community.service.MarathonService;
import store.seub2hu2.community.service.NoticeService;
import store.seub2hu2.community.vo.Marathon;
import store.seub2hu2.community.vo.Notice;
import store.seub2hu2.course.service.UserCourseService;
import store.seub2hu2.lesson.service.LessonFileService;
import store.seub2hu2.lesson.service.LessonService;
import store.seub2hu2.mypage.dto.AnswerDTO;
import store.seub2hu2.mypage.dto.QnaResponse;
import store.seub2hu2.mypage.service.QnaService;
import store.seub2hu2.product.service.ProductService;
import store.seub2hu2.security.user.LoginUser;
import store.seub2hu2.user.service.UserService;
import store.seub2hu2.util.ListDto;

import java.util.Date;
import java.util.HashMap;
import java.util.Map;

@Controller
@RequestMapping("/admin/community")
@RequiredArgsConstructor
@Slf4j
public class AdminCommunityController {

    private final AdminService adminService;
    private final QnaService qnaService;
    private final MarathonService marathonService;
    private final NoticeService noticeService;

    @GetMapping("/qna")
    public String qna(@ModelAttribute RequestParamsDto dto , Model model, @AuthenticationPrincipal LoginUser loginUser) {

        ListDto<QnaResponse> qnaDto = qnaService.getQnas(dto,loginUser.getNo());

        model.addAttribute("qnaList", qnaDto.getData());
        model.addAttribute("pagination", qnaDto.getPaging());

        return "admin/community/qnalist";
    }

    @GetMapping("/qna/{qnaNo}")
    public String qnaDetailPage(@PathVariable("qnaNo") int qnaNo, Model model){

        QnaResponse qnaResponse = qnaService.getQnaByQnaNo(qnaNo);

        model.addAttribute("qna",qnaResponse);

        return "admin/community/answer-form";
    }

    @PostMapping("/qna/answer")
    public String qnaAnswerPage(@ModelAttribute AnswerDTO answerDTO, @AuthenticationPrincipal LoginUser loginUser){

        qnaService.updateAnswer(answerDTO, loginUser.getNo());

        return "redirect:/admin/community/qna";
    }

    @PostMapping("/updateReport")
    public String updateReport(@RequestParam("reportNo") int reportNo,
                               @RequestParam("reportType") String reportType,
                               Model model) {

        Map<String, Object> condition = new HashMap<>();
        condition.put("reportNo", reportNo);
        condition.put("reportType", reportType);

        adminService.UpdateReport(condition);



        return "redirect:/admin/community/report";
    }

    @GetMapping("/report")
    public String report(@RequestParam(name = "page", required = false, defaultValue = "1") int page,
                         @RequestParam(name = "rows", required = false, defaultValue = "10") int rows,
                         @RequestParam(name = "sort", required = false, defaultValue = "latest") String sort,
                         @RequestParam(name = "opt", required = false) String opt,
                         @RequestParam(name = "value", required = false) String value,
                         @RequestParam(name = "keyword", required = false) String keyword,
                         Model model) {

        Map<String, Object> condition = new HashMap<>();
        condition.put("page", page);
        condition.put("rows", rows);
        condition.put("sort", sort);

        if (StringUtils.hasText(value)) {
            condition.put("opt", opt);
            condition.put("keyword", keyword);
            condition.put("value", value);

        }

        ListDto<ReportDto> dto = adminService.getReport(condition);

        model.addAttribute("dto", dto.getData());
        model.addAttribute("paging", dto.getPaging());

        return "admin/community/reportlist";
    }

    @GetMapping("/community")
    public String community() {

        return "admin/community";
    }

    @GetMapping("/notice")
    public String notice(@RequestParam(name = "page", required = false, defaultValue = "1") int page
            , @RequestParam(name = "rows", required = false, defaultValue = "10") int rows
            , @RequestParam(name = "sort", required = false, defaultValue = "import") String sort
            , @RequestParam(name = "opt", required = false) String opt
            , @RequestParam(name = "keyword", required = false) String keyword
            , Model model) {

        Map<String, Object> condition = new HashMap<>();
        condition.put("page", page);
        condition.put("rows", rows);
        condition.put("sort", sort);

        if (StringUtils.hasText(keyword)) {
            condition.put("opt", opt);
            condition.put("keyword", keyword);
        }

        ListDto<Notice> dto = noticeService.getNotices(condition);

        model.addAttribute("notices", dto.getData());
        model.addAttribute("paging", dto.getPaging());


        return "admin/community/notice";
    }

    @GetMapping("/marathon")
    public String marathon(@RequestParam(name = "page", required = false, defaultValue = "1") int page
            , @RequestParam(name = "rows", required = false, defaultValue = "6") int rows
            , @RequestParam(name = "opt", required = false) String opt
            , @RequestParam(name = "category", required = false) String category
            , @RequestParam(name = "keyword", required = false) String keyword
            , Model model) {

        Map<String, Object> condition = new HashMap<>();
        condition.put("page", page);
        condition.put("rows", rows);

        // 카테고리 필터링 처리
        if (StringUtils.hasText(category)) {
            condition.put("category", category);
        }

        // 검색
        if (StringUtils.hasText(keyword)) {
            condition.put("opt", opt);
            condition.put("keyword", keyword);
        }

        ListDto<Marathon> dto = marathonService.getMarathons(condition);

        model.addAttribute("marathons", dto.getData());
        model.addAttribute("paging", dto.getPaging());
        model.addAttribute("now", new Date());

        return "admin/community/marathon";
    }
}
