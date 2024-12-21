package store.seub2hu2.lesson.service;

import lombok.RequiredArgsConstructor;

import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;
import store.seub2hu2.lesson.dto.LessonRegisterForm;
import store.seub2hu2.lesson.dto.LessonUpdateForm;
import store.seub2hu2.lesson.enums.LessonStatus;
import store.seub2hu2.lesson.mapper.LessonFileMapper;
import store.seub2hu2.lesson.mapper.LessonMapper;
import store.seub2hu2.lesson.mapper.LessonReservationMapper;
import store.seub2hu2.lesson.vo.*;
import store.seub2hu2.user.mapper.UserMapper;
import store.seub2hu2.user.vo.User;

import java.util.*;

@Service
@RequiredArgsConstructor
@Slf4j
public class LessonService {

    private final LessonMapper lessonMapper;
    private final LessonFileMapper lessonFileMapper;
    private final LessonFileService lessonFileService;
    private final LessonReservationMapper lessonReservationMapper;
    private final UserMapper userMapper;

    public List<Lesson> getAllLessons(Map<String, Object> param, String subject) {
        return lessonMapper.getAllLessons(param, subject);
    }

    public Lesson getLessonByNo(int lessonNo) {
        return lessonMapper.getLessonByNo(lessonNo);
    }

    public List<LessonReservation> getLessonsByUserId(String userId) {
        return lessonReservationMapper.getLessonReservationByUserId(userId);
    }

    public void addNewLesson(Lesson lesson) {
        lessonMapper.insertLesson(lesson);
    }

    public void registerLesson(LessonRegisterForm form) {
        // Convert LessonRegisterForm to Lesson
        Lesson lesson = new Lesson();
        lesson.setTitle(form.getTitle());
        lesson.setPrice(form.getPrice());
        User user = userMapper.getUserById(form.getLecturerId());
        lesson.setLecturer(user);
        lesson.setPlace(form.getPlace());
        lesson.setSubject(form.getSubject());
        lesson.setPlan(form.getPlan());
        lesson.setStart(form.getStart());
        lesson.setEnd(form.getEnd());

        lessonMapper.insertLesson(lesson); // Save lesson details and generate lessonNo

        // Save thumbnail and main images
        lessonFileService.saveLessonImages(getMostLatelyLessonNo(), form.getThumbnail(), form.getMainImage());

    }

    public int getMostLatelyLessonNo() {
        return lessonFileMapper.lastInsertedLessonNo();
    }

    public void updateLesson(LessonUpdateForm dto) {
        lessonMapper.updateLesson(dto);
        // 1
        log.info("dto.getThumbnail(): {}" , dto.getThumbnail());

        lessonFileService.updateLessonImages(getMostLatelyLessonNo(), dto.getThumbnail(), dto.getMainImage());
    }

    public Map<String, String> getStartAndEnd (int lessonNo) {
        Map<String, String> map = new HashMap<>();
        Lesson lesson = lessonMapper.getLessonByNo(lessonNo);
        map.put("startDate", lesson.getStartDate());
        map.put("startTime" ,lesson.getStartTime());
        map.put("endDate", lesson.getEndDate());
        map.put("endTime" ,lesson.getEndTime());

        return map;
    }

    public void updatePastLessons() {
        // 업데이트할 상태를 설정
        LessonUpdateForm dto = new LessonUpdateForm();
        dto.setStatus(LessonStatus.CLOSE.label());

        // 매퍼 호출
        lessonMapper.updatePastLessonStatus(dto);
        System.out.println("지난 레슨 상태가 업데이트되었습니다.");
    }

}
