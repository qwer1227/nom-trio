package store.seub2hu2.admin.controller;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.format.annotation.DateTimeFormat;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.util.StringUtils;
import org.springframework.validation.BindingResult;
import org.springframework.validation.annotation.Validated;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;
import store.seub2hu2.admin.dto.*;
import store.seub2hu2.admin.service.AdminService;
import store.seub2hu2.community.service.MarathonService;
import store.seub2hu2.community.service.NoticeService;
import store.seub2hu2.community.vo.Marathon;
import store.seub2hu2.community.vo.Notice;
import store.seub2hu2.course.service.CourseService;
import store.seub2hu2.course.service.UserCourseService;
import store.seub2hu2.course.vo.Course;
import store.seub2hu2.lesson.dto.LessonRegisterForm;
import store.seub2hu2.lesson.dto.LessonUpdateForm;
import store.seub2hu2.lesson.service.LessonFileService;
import store.seub2hu2.lesson.service.LessonService;
import store.seub2hu2.lesson.vo.Lesson;
import store.seub2hu2.mypage.dto.AnswerDTO;
import store.seub2hu2.mypage.dto.QnaResponse;
import store.seub2hu2.mypage.service.QnaService;
import store.seub2hu2.product.dto.*;
import store.seub2hu2.product.service.ProductService;
import store.seub2hu2.product.vo.*;
import store.seub2hu2.product.vo.Category;
import store.seub2hu2.product.vo.Color;
import store.seub2hu2.product.vo.Image;
import store.seub2hu2.product.vo.Product;
import store.seub2hu2.security.user.LoginUser;
import store.seub2hu2.user.service.UserService;
import store.seub2hu2.user.vo.User;
import store.seub2hu2.util.ListDto;

import java.io.IOException;
import java.text.SimpleDateFormat;
import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.util.*;


@Controller
@RequestMapping("/admin")
@RequiredArgsConstructor
@Slf4j
public class AdminController {

    private final CourseService courseService;
    private final AdminService adminService;
    private final LessonService lessonService;
    private final LessonFileService lessonFileService;
    private final ProductService productService;
    private final UserService userService;
    private final QnaService qnaService;
    private final UserCourseService userCourseService;
    private final MarathonService marathonService;
    private final NoticeService noticeService;

    @GetMapping("/home")
    public String home() {

        return "admin/home";
    }


    @GetMapping("/product-stock-detail")
    public String getProductStockDetail(@RequestParam("no") int no,
                                        @RequestParam("colorNo") Integer colorNo,
                                        @RequestParam(name = "colorName", required = false) String colorName,
                                        Model model) {

        Product product = adminService.getProductNo(no);
        List<Color> colors = adminService.getColorName(no);
        List<Size> sizes = adminService.getAllSizeByColorNo(colorNo);

        Map<String, Object> condition = new HashMap<>();
        condition.put("no", no);
        condition.put("colorName", colorName);

        List<Color> colorSize = adminService.getStockByColorNum(condition);


        if (colorSize == null || colorSize.isEmpty()) {
            model.addAttribute("colorSize", null);
            model.addAttribute("sizeMessage", "사이즈 정보가 없습니다.");

        } else {
            model.addAttribute("colorSize", colorSize);
            model.addAttribute("sizeMessage", null);


        }

        model.addAttribute("colorSize", colorSize);
        model.addAttribute("sizes", sizes);
        model.addAttribute("product", product);
        model.addAttribute("colors", colors);

        return "admin/product-stock-detail";
    }

    @PostMapping("/product-stock-detail")
    public String productStockDetail(@RequestParam("no") int no,
                                     @RequestParam(name = "colorNo") Integer colorNo,
                                     @RequestParam(name = "colorName", required = false) String colorName,
                                     @RequestParam("size") List<String> size,
                                     @RequestParam("amount") List<Integer> amount,
                                     Model model) {

        Map<String, Object> condition = new HashMap<>();
        condition.put("no", no);
        condition.put("colorName", colorName);

        for (int i = 0; i < size.size(); i++) {
            String currentSize = size.get(i);
            Integer currentAmount = amount.get(i);

            condition.put("size", currentSize);
            condition.put("amount", currentAmount);


            adminService.getInsertStock(condition);
        }

        return "redirect:/admin/product-detail?no=" + no + "&colorNo=" + colorNo;
    }

    @GetMapping("/product-stock")
    public String getProductStock(@RequestParam(name = "topNo") int topNo,
                                  @RequestParam(name = "catNo", required = false, defaultValue = "0") int catNo,
                                  @RequestParam(name = "page", required = false, defaultValue = "1") int page,
                                  @RequestParam(name = "rows", required = false, defaultValue = "10") int rows,
                                  @RequestParam(name = "sort", required = false, defaultValue = "date") String sort,
                                  @RequestParam(name = "opt", required = false) String opt,
                                  @RequestParam(name = "value", required = false) String value,

                                  Model model) {

        Map<String, Object> condition = new HashMap<>();
        condition.put("topNo", topNo);
        if (catNo != 0) {
            condition.put("catNo", catNo);
        }

        condition.put("page", page);
        condition.put("rows", rows);
        condition.put("sort", sort);
        if(StringUtils.hasText(opt)) {
            condition.put("opt", opt);
            condition.put("value", value);
        }

        ListDto<ProdListDto> dto = adminService.getStockProduct(condition);
        model.addAttribute("topNo", topNo);
        model.addAttribute("catNo", catNo);
        model.addAttribute("products", dto.getData());
        model.addAttribute("paging", dto.getPaging());

        return "admin/product-stock";
    }

    @PostMapping("/product-stock")
    public String productStock(@RequestParam("Y") String Y,
                               @RequestParam("no") int no,
                               @RequestParam("topNo") int topNo){

        Map<String, Object> condition = new HashMap<>();
        condition.put("Y", Y);
        condition.put("no", no);

        adminService.getDeletedProd(condition);

        return  "redirect:/admin/product-stock?topNo=" + topNo;
    }

    @PostMapping("/product-show")
    public String productShow(@RequestParam("no") int no,
                              @RequestParam("topNo") int topNo,
                              @RequestParam("show") String show) {


        Map<String, Object> condition = new HashMap<>();
        condition.put("no", no);
        condition.put("show", show);

        // 노출 상태 변경 처리
        adminService.updateProductShowStatus(condition);

        return "redirect:/admin/product-stock?topNo=" + topNo;
    }


    @PostMapping("/updateDeliveryStatus")
    public String updateDeliveryStatus(@RequestParam(name="page", required = false,defaultValue ="1") int page,
                                       @RequestParam(name="rows", required = false,defaultValue ="10") int rows,
                                       @RequestParam(name="day", required = false) String day,
                                       @RequestParam("deliNo") int deliNo,
                                       @RequestParam("deliStatus") String deliStatus) {

        Map<String, Object> condition = new HashMap<>();
        condition.put("deliNo", deliNo);
        condition.put("deliStatus", deliStatus);

        System.out.println("----------------condition" + condition);

        adminService.getUpdateDelivery(condition);


        return "redirect:/admin/order-delivery?page=" + page + "&rows" + rows + "&day=" + day;
    }

    @GetMapping("/order-delivery")
    public String order(@RequestParam(name = "page", required = false, defaultValue = "1") int page,
                        @RequestParam(name = "rows", required = false, defaultValue = "10") int rows,
                        @RequestParam(name = "day", required = false) String day,
                        @RequestParam(name = "sort", required = false, defaultValue = "latest") String sort,
                        @RequestParam(name = "opt", required = false) String opt,
                        @RequestParam(name = "keyword", required = false) String keyword,
                        @RequestParam(name = "value", required = false) String value,
                        Model model){

        if (day == null || day.isEmpty()) {
            // 현재 날짜로 기본 설정
            SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
            day = sdf.format(new Date());
        }

        Map<String, Object> condition = new HashMap<>();
        condition.put("page", page);
        condition.put("rows", rows);
        condition.put("day", day);
        condition.put("sort", sort);

        if(StringUtils.hasText(opt)) {
            condition.put("opt", opt);
            condition.put("keyword", keyword);
            condition.put("value", value);
        }


        ListDto<orderDeliveryDto> dto = adminService.getOrderDelivery(condition);

        model.addAttribute("dto", dto.getData());
        model.addAttribute("paging", dto.getPaging());

        return "admin/order-delivery";
    }



    @GetMapping("/chart")
    public Map<String, Object> chart(@RequestParam(name = "day", required = false) String day,

                                     Model model) {

        if (day == null || day.isEmpty()) {
            // 현재 날짜로 기본 설정
            SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
            day = sdf.format(new Date());
        }

        Map<String, Object> conditions = adminService.getTotalSubject(day);

        model.addAttribute("conditions", conditions);

        return conditions;
    }

    @GetMapping("/p-settlement/preview")
    @ResponseBody
    public List<prevOrderProdDto> prodPreview(@RequestParam("orderNo") int orderNo
    ) {

        List<prevOrderProdDto> dtos = adminService.getOrderProdPrev(orderNo);


        return dtos;
    }

    @GetMapping("/p-settlement")
    public String pSettlement(@RequestParam(name = "page", required = false, defaultValue = "1") int page,
                              @RequestParam(name = "rows", required = false, defaultValue = "10") int rows,
                              @RequestParam(name = "sort", required = false) String sort,
                              @RequestParam(name = "opt", required = false, defaultValue = "all") String opt,
                              @RequestParam(name = "day", required = false) String day,
                              @RequestParam(name = "keyword", required = false, defaultValue = "all") String keyword,
                              @RequestParam(name = "value", required = false) String value,
                              Model model) {

        if (day == null || day.isEmpty()) {
            // 현재 날짜로 기본 설정
            SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
            day = sdf.format(new Date());
        }

            Map<String, Object> condition = new HashMap<>();
            condition.put("page", page);
            condition.put("rows", rows);
            condition.put("sort", sort);
            condition.put("opt", opt);

            if (StringUtils.hasText(day)) {
                condition.put("day", day);
            }

            if (StringUtils.hasText(value)) {
                condition.put("keyword", keyword);
                condition.put("value", value);
            }

            ListDto<OrderProductDto> dto = adminService.getOrderProduct(condition);

            int totalPriceSum = dto.getData().stream()
                    .mapToInt(OrderProductDto::getTotalPrice)
                    .distinct()   // 중복된 값 제거 (한 번만 합산)
                    .limit(1)     // 첫 번째 값만 선택
                    .sum();

            model.addAttribute("totalPriceSum", totalPriceSum);

            model.addAttribute("dto", dto.getData());
            model.addAttribute("paging", dto.getPaging());

            return "admin/p-settlement";
    }

    @GetMapping("/settlement")
    public String settlement(@RequestParam(name = "page", required = false, defaultValue = "1") int page,
                             @RequestParam(name = "rows", required = false, defaultValue = "10") int rows,
                             @RequestParam(name = "pType", required = false, defaultValue = "lesson") String pType,
                             @RequestParam(name = "day", required = false) String day,
                             @RequestParam(name = "sort", required = false, defaultValue ="latest") String sort,
                             @RequestParam(name = "opt", required = false, defaultValue = "all") String opt,
                             @RequestParam(name = "keyword", required = false) String keyword,
                             @RequestParam(name = "value", required = false) String value,
                             Model model) {

        if (day == null || day.isEmpty()) {
            // 현재 날짜로 기본 설정
            SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
            day = sdf.format(new Date());
        }


        Map<String, Object> condition = new HashMap<>();
        condition.put("page", page);
        condition.put("rows", rows);
        condition.put("pType", pType);

        condition.put("sort", sort);
        condition.put("opt", opt);

        if (StringUtils.hasText(day)) {
            condition.put("day", day);
        }

        if (StringUtils.hasText(value)) {
            condition.put("keyword", keyword);
            condition.put("value", value);
        }

        ListDto<SettlementDto> dto = adminService.getSettleList(condition);

        int totalPriceSum = dto.getData().stream()
                .mapToInt(SettlementDto::getTotalPrice)
                .distinct()   // 중복된 값 제거 (한 번만 합산)
                .limit(1)     // 첫 번째 값만 선택
                .sum();

        model.addAttribute("totalPriceSum", totalPriceSum);
        model.addAttribute("dto", dto.getData());
        model.addAttribute("paging", dto.getPaging());

        return "admin/settlement";
    }

    @GetMapping("/qna")
    public String qna(@ModelAttribute RequestParamsDto dto ,Model model, @AuthenticationPrincipal LoginUser loginUser) {

//        // 검색 조건이 'status'일 때, keyword 값을 0, 1, 2로 변환
//        if ("status".equals(dto.getOpt()) && StringUtils.hasText(dto.getKeyword())) {
//            String status = dto.getKeyword();
//            // "대기", "완료", "삭제"를 0, 1, 2로 변환
//            if ("대기".equals(status)) {
//                condition.put("keyword", 0);
//            } else if ("완료".equals(status)) {
//                condition.put("keyword", 1);
//            } else if ("삭제".equals(status)) {
//                condition.put("keyword", 2);
//            }
//        }

        ListDto<QnaResponse> qnaDto = qnaService.getQnas(dto,loginUser.getNo());

        model.addAttribute("qnaList", qnaDto.getData());
        model.addAttribute("pagination", qnaDto.getPaging());

        return "admin/qnalist";
    }

    @GetMapping("/qna/{qnaNo}")
    public String qnaDetailPage(@PathVariable("qnaNo") int qnaNo, Model model){

        QnaResponse qnaResponse = qnaService.getQnaByQnaNo(qnaNo);

        model.addAttribute("qna",qnaResponse);

        return "admin/answer-form";
    }

    @PostMapping("/qna/answer")
    public String qnaAnswerPage(@ModelAttribute AnswerDTO answerDTO, @AuthenticationPrincipal LoginUser loginUser){

        qnaService.updateAnswer(answerDTO, loginUser.getNo());

        return "redirect:/admin/qna";
    }

    @PostMapping("/updateReport")
    public String updateReport(@RequestParam("reportNo") int reportNo,
                               @RequestParam("reportType") String reportType,
                               Model model) {

        Map<String, Object> condition = new HashMap<>();
        condition.put("reportNo", reportNo);
        condition.put("reportType", reportType);

        adminService.UpdateReport(condition);



        return "redirect:/admin/report";
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

        return "admin/reportlist";
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


        return "admin/notice";
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

        return "admin/marathon";
    }
}
