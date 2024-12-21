package store.seub2hu2.lesson.scheduler;

import lombok.RequiredArgsConstructor;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Component;
import store.seub2hu2.lesson.service.LessonService;

@Component
@RequiredArgsConstructor
public class LessonStatusScheduler {

    private final LessonService lessonService;

    // 매일 자정 실행
    @Scheduled(cron = "0 0 0 * * ?")
//    @Scheduled(fixedRate = 5000)
    public void scheduleLessonStatusUpdate() {
        lessonService.updatePastLessons();
        System.out.println("스케줄러 실행: 지난 레슨 상태 업데이트 완료");
    }

}
