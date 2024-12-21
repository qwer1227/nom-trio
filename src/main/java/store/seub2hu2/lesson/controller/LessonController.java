package store.seub2hu2.lesson.controller;

import jakarta.servlet.http.HttpServletResponse;
import lombok.RequiredArgsConstructor;

import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.beans.propertyeditors.CustomDateEditor;
import org.springframework.http.HttpEntity;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.WebDataBinder;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;
import retrofit2.http.GET;
import store.seub2hu2.lesson.dto.LessonDto;
import store.seub2hu2.lesson.dto.LessonRegisterForm;
import store.seub2hu2.lesson.dto.ReservationSearchCondition;
import store.seub2hu2.lesson.service.LessonFileService;
import store.seub2hu2.lesson.service.LessonReservationService;
import store.seub2hu2.lesson.service.LessonService;
import store.seub2hu2.lesson.vo.*;
import store.seub2hu2.security.user.LoginUser;
import store.seub2hu2.user.vo.User;

import java.io.IOException;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@RequiredArgsConstructor
@Controller
@RequestMapping("/lesson")
@Slf4j
public class LessonController {

    private final LessonReservationService lessonReservationService;
    private final LessonService lessonService;
    private final LessonFileService lessonFileService;

    @GetMapping(value = {"/", "lessons", ""})
    public String lessonList() {

        return "lesson/lesson-home";
    }

    @GetMapping("/schedule")
    public String home() {
        return "lesson/lesson-schedule";
    }

    @GetMapping("/list")
    @ResponseBody
    public List<Lesson> lesson(@RequestParam("start") String start,
                               @RequestParam("end") String end,
                               @RequestParam(value = "includeCompleted", required = false, defaultValue = "false") boolean includeCompleted,
                               @RequestParam(value = "subject", required = false, defaultValue = "전체") String subject) {
        Map<String, Object> param = new HashMap<>();
        param.put("start", start);
        param.put("end", end);
        param.put("includeCompleted", includeCompleted);
        List<Lesson> lessons = lessonService.getAllLessons(param, subject);

        return lessons;
    }

    @GetMapping("/detail")
    public String lessonDetail(@RequestParam("lessonNo") Integer lessonNo, Model model) {
        try {
            // Lesson 정보 가져오기
            Lesson lesson = lessonService.getLessonByNo(lessonNo);
            String startDate = lesson.getStartDate();
            String startTime = lesson.getStartTime();
            String endTime = lesson.getEndTime();

            // 이미지 파일 정보 가져오기
            Map<String, String> images = lessonFileService.getImagesByLessonNo(lessonNo);

            // 모델에 lesson과 images 정보 추가
            model.addAttribute("lesson", lesson);
            model.addAttribute("startDate", startDate);
            model.addAttribute("startTime", startTime);
            model.addAttribute("endTime", endTime);
            model.addAttribute("lessonNo", lessonNo);
            model.addAttribute("images", images);

            log.info("lesson start = {}", lesson);
            return "lesson/lesson-detail";
        } catch (NumberFormatException e) {
            throw new IllegalArgumentException("Invalid lessonNo: " + lessonNo);
        }
    }

    @PreAuthorize("isAuthenticated()")
    @GetMapping("/reservation")
    public String reservation(@AuthenticationPrincipal LoginUser loginUser,
                              @ModelAttribute("condition") ReservationSearchCondition condition,
                              Model model) {

        LocalDate now = LocalDate.now();

        if (condition.getStart() == null && condition.getEnd() == null) {
            condition.setEnd(now); // 기본 종료 날짜: 오늘
            condition.setStart(now.minusMonths(1)); // 기본 시작 날짜: 한 달 전
        } else {
            // 종료 날짜가 null인 경우 기본값 설정
            if (condition.getEnd() == null) {
                condition.setEnd(now);
            }
            // 시작 날짜가 null인 경우 기본값 설정
            if (condition.getStart() == null) {
                condition.setStart(now.minusMonths(1));
            }
        }

        List<LessonReservation> lessonReservations = lessonReservationService.searchLessonReservationList(condition, loginUser.getId());
        model.addAttribute("lessonReservations", lessonReservations);
        return "lesson/lesson-reservation";
    }

    @PreAuthorize("isAuthenticated()")
    @GetMapping("/reservation/detail")
    public String reservationDetail(@RequestParam("reservationNo") int reservationNo,
                                    Model model) {
        LessonReservation lessonReservation = lessonReservationService.getLessonReservationByNo(reservationNo);
        int lessonNo = lessonReservation.getLesson().getLessonNo();
        Lesson lesson = lessonService.getLessonByNo(lessonNo);
        String startDate = lesson.getStartDate();
        String startTime = lesson.getStartTime();
        Map<String, String> images = lessonFileService.getImagesByLessonNo(lessonNo);
        model.addAttribute("lessonReservation", lessonReservation);
        model.addAttribute("images", images);
        model.addAttribute("startDate", startDate);
        model.addAttribute("startTime", startTime);
        return "lesson/lesson-reservation-detail";
    }

    @GetMapping("/error-500")
    public void error500(HttpServletResponse response) throws IOException {
        response.sendError(500);
    }
}
