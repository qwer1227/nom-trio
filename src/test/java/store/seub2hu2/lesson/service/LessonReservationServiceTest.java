package store.seub2hu2.lesson.service;


import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;
import store.seub2hu2.lesson.enums.LessonStatus;

import java.time.LocalDate;
import java.util.concurrent.CountDownLatch;
import java.util.concurrent.ExecutorService;
import java.util.concurrent.Executors;

import static org.assertj.core.api.Assertions.assertThat;

@SpringBootTest
public class LessonReservationServiceTest {

    @Autowired
    private LessonReservationService lessonReservationService;

    @Autowired
    private LessonService lessonService;



//    @Test
//    @DisplayName("예약 동시성 테스트")
//    void concurrency_order_test() throws InterruptedException {
        // Given
//        int numThreads = 30;
//        ExecutorService executor = Executors.newFixedThreadPool(numThreads);
//        CountDownLatch latch = new CountDownLatch(numThreads);
//
//        // When
//        for (int i = 0; i < numThreads; i += 1) {
//            executor.submit(() -> {
//                LessonReservationPaymentDto dto = new LessonReservationPaymentDto();
//                dto.setLessonNo(2);
//                dto.setQuantity(1);
//                dto.setTitle("레슨");
//                dto.setPrice(10000);
//                dto.setUserNo(29);
//                dto.setPayNo("test" + System.nanoTime());
//
//                try {
//                    lessonReservationService.saveLessonReservation(dto);
//                } catch (IllegalStateException e) {
//                    System.out.println("예약 실패: " + e.getMessage());
//                } finally {
//                    latch.countDown();
//                }
//            });
//        }
//
//        latch.await();
//        executor.shutdown();
//
//        // Then
//
//        assertThat(lessonService.getLessonByNo(2).getParticipant()).isEqualTo(5);
//
//    }

    @Test
    public void timeTest() throws InterruptedException {
        System.out.println("localDate now = " + LocalDate.now());
    }
}




