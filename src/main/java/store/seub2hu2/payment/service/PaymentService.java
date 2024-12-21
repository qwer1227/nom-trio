package store.seub2hu2.payment.service;

import lombok.RequiredArgsConstructor;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import store.seub2hu2.payment.dto.PaymentDto;
import store.seub2hu2.payment.mapper.PayMapper;
import store.seub2hu2.payment.vo.Payment;

@Service
@RequiredArgsConstructor
public class PaymentService {

    private final PayMapper payMapper;

    public PaymentDto getPaymentById(String id) {
        Payment payment = payMapper.getPaymentById(id);
        return new PaymentDto(payment);
    }

    public String getPaymentTypeById(String id) {
        return payMapper.getPaymentTypeById(id);
    }

    public void completeLessonPayment() {
        payMapper.updateLessonPayStatus();
    }
}
