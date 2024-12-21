package store.seub2hu2.payment.scheduler;

import lombok.RequiredArgsConstructor;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Component;
import store.seub2hu2.payment.service.PaymentService;

@RequiredArgsConstructor
@Component
public class PaymentScheduler {

    private final PaymentService paymentService;


    @Scheduled(cron = "0 0 0 * * ?")
//    @Scheduled(fixedRate = 5000)
    public void schedulePaymentStatusUpdate() {
        paymentService.completeLessonPayment();
        System.out.println("스케줄러 실행: 지난 레슨 결제 상태 업데이트 완료");
    }

}
