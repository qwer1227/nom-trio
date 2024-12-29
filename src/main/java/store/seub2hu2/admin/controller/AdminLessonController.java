package store.seub2hu2.admin.controller;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.format.annotation.DateTimeFormat;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.util.StringUtils;
import org.springframework.validation.BindingResult;
import org.springframework.validation.annotation.Validated;
import org.springframework.web.bind.annotation.*;
import store.seub2hu2.admin.dto.LessonUsersDto;
import store.seub2hu2.admin.service.AdminService;
import store.seub2hu2.lesson.dto.LessonRegisterForm;
import store.seub2hu2.lesson.dto.LessonUpdateForm;
import store.seub2hu2.lesson.service.LessonFileService;
import store.seub2hu2.lesson.service.LessonService;
import store.seub2hu2.lesson.vo.Lesson;
import store.seub2hu2.user.service.UserService;
import store.seub2hu2.user.vo.User;

import java.io.IOException;
import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Controller
@RequestMapping("/admin/lesson")
@RequiredArgsConstructor
@Slf4j
public class AdminLessonController {

    private final AdminService adminService;
    private final UserService userService;
    private final LessonService lessonService;
    private final LessonFileService lessonFileService;

    @GetMapping("/lesson-edit-form")
    public String lessonEditForm(@RequestParam("lessonNo") Integer lessonNo, Model model) {
        try {
            // 강사 정보 가져오기
            List<User> lecturers = userService.findUsersByUserRoleNo(3);

            // Lesson 정보 가져오기
            Lesson lesson = lessonService.getLessonByNo(lessonNo);
            LessonUpdateForm form = new LessonUpdateForm();
            form.setLessonNo(lessonNo);
            form.setTitle(lesson.getTitle());
            form.setPlan(lesson.getPlan());
            form.setPrice(lesson.getPrice());
            form.setSubject(lesson.getSubject());
            form.setStatus(lesson.getStatus());
            form.setStart(lesson.getStartDate() + " " + lesson.getStartTime());
            form.setEnd(lesson.getEndDate() + " " + lesson.getEndTime());

            // 이미지 파일 정보 가져오기
            Map<String, String> images = lessonFileService.getImagesByLessonNo(lessonNo);

            // 모델에 레슨, 이미지, 강사 정보 추가
            model.addAttribute("lecturers", lecturers);
            model.addAttribute("lesson", lesson);
            model.addAttribute("lessonNo", lessonNo);
            model.addAttribute("images", images);
            model.addAttribute("form", form);

            log.info("lesson start = {}", lesson);

            return "admin/lesson-edit-form";
        } catch (NumberFormatException e) {
            throw new IllegalArgumentException("Invalid lessonNo: " + lessonNo);
        }
    }

    @PostMapping("/lesson-edit-form")
    public String lessonEditForm(@Validated @ModelAttribute("form") LessonUpdateForm form, BindingResult result, Model model) {
        if (!StringUtils.hasText(form.getPlan()) && form.getMainImage().isEmpty()) {
            result.rejectValue("plan", null, "계획을 작성하거나 메인 이미지를 첨부 해주세요.");
            result.rejectValue("mainImage", null, "계획을 작성하거나 메인 이미지를 첨부 해주세요.");
        }

        if(form.getThumbnail().isEmpty()) {
            result.rejectValue("thumbnail", null, "썸네일을 첨부 해주세요.");
        }

        if (result.hasErrors()) {
            // 강사 정보 가져오기
            List<User> lecturers = userService.findUsersByUserRoleNo(3);

            // Lesson 정보 가져오기
            int lessonNo = form.getLessonNo();
            Lesson lesson = lessonService.getLessonByNo(lessonNo);

            // 이미지 파일 정보 가져오기
            Map<String, String> images = lessonFileService.getImagesByLessonNo(lessonNo);

            // 모델에 레슨, 이미지, 강사 정보 추가
            model.addAttribute("lecturers", lecturers);
            model.addAttribute("lesson", lesson);
            model.addAttribute("lessonNo", lessonNo);
            model.addAttribute("images", images);
            model.addAttribute("form", form);

            log.info("lesson start = {}", lesson);

            return "admin/lesson-edit-form";
        }

        log.info("레슨 수정 정보 {} ", form);
        lessonService.updateLesson(form);

        return "redirect:/admin/lesson";
    }

    @GetMapping("/lesson-register-form")
    public String lessonRegisterForm(Model model) {

        // 사용자 권한이 강사인 사용자 목록을 조회한다.
        List<User> lecturers = userService.findUsersByUserRoleNo(3);
        model.addAttribute("lecturers", lecturers);
        model.addAttribute("form", new LessonRegisterForm());

        return "admin/lesson-register-form";
    }

    @PostMapping("/lesson-register-form")
    public String form(@Validated @ModelAttribute("form") LessonRegisterForm form, BindingResult result, Model model) throws IOException {

        if (!StringUtils.hasText(form.getPlan()) && form.getMainImage().isEmpty()) {
            result.rejectValue("plan", null, "계획을 작성하거나 메인 이미지를 첨부 해주세요.");
            result.rejectValue("mainImage", null, "계획을 작성하거나 메인 이미지를 첨부 해주세요.");
        }

        if(form.getThumbnail().isEmpty()) {
            result.rejectValue("thumbnail", null, "썸네일을 첨부 해주세요.");
        }

        if (result.hasErrors()) {
            // 강사 목록 전달
            List<User> lecturers = userService.findUsersByUserRoleNo(3);
            model.addAttribute("lecturers", lecturers);

            return "admin/lesson-register-form"; // 오류가 있는 경우 다시 폼 페이지로 리턴
        }

        lessonService.registerLesson(form);

        return "redirect:/admin/lesson";
    }

    @GetMapping("/lesson/preview")
    @ResponseBody
    public List<LessonUsersDto> lessonPreview(@RequestParam("no") Integer lessonNo,
                                              Model model) {

        List<LessonUsersDto> reservations = adminService.getLessonUser(lessonNo);


        return reservations;
    }

    @GetMapping("/lesson")
    public String lesson(@RequestParam(name = "opt", required = false) String opt,
                         @RequestParam(name = "day", required = false)
                         @DateTimeFormat(pattern = "yyyy-MM-dd") LocalDate day,
                         @RequestParam(name = "value", required = false) String value,
                         Model model) {

        if (day == null) {
            day = LocalDate.now();
        }

        String formattedDay = day.format(DateTimeFormatter.ofPattern("yyyy-MM-dd"));

        Map<String, Object> condition = new HashMap<>();
        condition.put("day", formattedDay);
        if (StringUtils.hasText(value)) {
            condition.put("opt", opt);
            condition.put("value", value);
        }

        List<Lesson> lessons = adminService.getLessons(condition);
        model.addAttribute("lessons", lessons);
        model.addAttribute("day", day); // 선택한 날짜를 다시 전달

        return "admin/lessonlist";
    }

}
