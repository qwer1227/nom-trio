package store.seub2hu2.lesson.scheduler;

import lombok.RequiredArgsConstructor;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Component;
import store.seub2hu2.lesson.service.LessonReservationService;

@RequiredArgsConstructor
@Component
public class LessonReservationScheduler {

    private final LessonReservationService lessonReservationService;

    // 매일 자정 실행
    @Scheduled(cron = "0 0 0 * * ?")
//    @Scheduled(fixedRate = 5000)
    public void scheduleLessonStatusUpdate() {
        lessonReservationService.completeReservation();
        System.out.println("스케줄러 실행: 지난 레슨 예약 상태 업데이트 완료");
    }

}
