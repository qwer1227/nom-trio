package store.seub2hu2.admin.controller;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.util.StringUtils;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;
import store.seub2hu2.admin.dto.CourseRegisterForm;
import store.seub2hu2.admin.service.AdminService;
import store.seub2hu2.course.service.CourseService;
import store.seub2hu2.course.vo.Course;
import store.seub2hu2.util.ListDto;

import java.util.HashMap;
import java.util.Map;

@Controller
@RequestMapping("/admin/course")
@RequiredArgsConstructor
@Slf4j
public class AdminCourseController {

    private final CourseService courseService;
    private final AdminService adminService;

    @PostMapping("/delete")
    public String courseDelete(@RequestParam("no") int courseNo){

        adminService.getDeletedCourse(courseNo);

        return "redirect:/admin/course/list";
    }

    @GetMapping("/edit-form")
    public String getCourseEditForm(@RequestParam("no") int courseNo, Model model) {

        Course course = adminService.getCourseByNo(courseNo);

        model.addAttribute("course", course);

        return "admin/course/edit-form";
    }

    @PostMapping("/edit-form")
    public String courseEditForm(@RequestParam Map<String, String> params,
                                 @RequestParam("no") int courseNo, CourseRegisterForm form,
                                 @RequestParam(value = "image", required = false) MultipartFile image,
                                 RedirectAttributes redirectAttributes) {

        // 유효성 검사
        if (params.get("name").isEmpty() ||
                params.get("time").isEmpty() ||
                params.get("level").isEmpty() ||
                params.get("distance").isEmpty() ||
                (image == null || image.isEmpty())) {

            redirectAttributes.addFlashAttribute("errorMessage", "모든 입력값을 입력해주세요.");
            return "redirect:/admin/course/edit-form";
        }

        adminService.getUpdateCourse(form);

        return "redirect:/admin/course/detail?no=" + courseNo;
    }

    @GetMapping("/course-register-form")
    public String courseRegisterForm() {
        return "admin/course-register-form";
    }

    @PostMapping("/course-register-form")
    public String courseRegisterForm(CourseRegisterForm form) {


        adminService.checkNewRegion(form);

        return "redirect:/admin/course/list";
    }

    @GetMapping("/detail")
    public String courseDetail(@RequestParam(name = "no") int courseNo,
                               Model model) {
        // 1. 코스의 상세 정보를 가져온다.
        Course course = courseService.getCourseDetail(courseNo);

        // 3. Model 객체에 코스의 상세 정보를 저장한다.
        model.addAttribute("course", course);

        return "admin/course/detail";
    }

    /*코스 목록*/
    @GetMapping("/list")
    public String course(@RequestParam(name = "page", required = false, defaultValue = "1") int page,
                         @RequestParam(name = "sort", required = false) String sort,
                         @RequestParam(name = "distance", required = false, defaultValue = "10") Double distance,
                         @RequestParam(name = "level", required = false) Integer level,
                         @RequestParam(name = "region", required = false) String region,
                         @RequestParam(name = "keyword", required = false) String keyword,
                         Model model) {
        // 1. 요청 파라미터 정보를 Map 객체에 담는다.
        Map<String, Object> condition = new HashMap<>();
        condition.put("page", page);
        if (StringUtils.hasText(sort)) {
            condition.put("sort", sort);
        }
        if (distance != null) {
            condition.put("distance", distance);
        }
        if (level != null) {
            condition.put("level", level);
        }
        if (StringUtils.hasText(keyword)) {
            condition.put("region", region);
            condition.put("keyword", keyword);
        }
        // 2. 검색에 해당하는 코스 목록을 가져온다.
        ListDto<Course> dto = courseService.getAllCourses(condition);

        // 3. Model 객체에 화면에 표시할 데이터를 저장해서 보낸다.
        model.addAttribute("courses", dto.getData());
        model.addAttribute("paging", dto.getPaging());

        return "admin/course/list";
    }
}
