package store.seub2hu2.lesson.service;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.apache.ibatis.annotations.Param;
import org.apache.xmlbeans.impl.xb.xsdschema.Attribute;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Isolation;
import org.springframework.transaction.annotation.Transactional;
import store.seub2hu2.lesson.dto.LessonUpdateForm;
import store.seub2hu2.lesson.dto.ReservationSearchCondition;
import store.seub2hu2.lesson.enums.LessonStatus;
import store.seub2hu2.lesson.enums.ReservationStatus;
import store.seub2hu2.payment.dto.PaymentDto;
import store.seub2hu2.lesson.mapper.LessonMapper;
import store.seub2hu2.lesson.mapper.LessonReservationMapper;
import store.seub2hu2.payment.mapper.PayMapper;
import store.seub2hu2.lesson.vo.Lesson;
import store.seub2hu2.lesson.vo.LessonReservation;
import store.seub2hu2.payment.vo.Payment;
import store.seub2hu2.user.vo.User;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.Calendar;
import java.util.List;

@Service
@RequiredArgsConstructor
@Slf4j
public class LessonReservationService {

    private final LessonService lessonService;
    private final LessonMapper lessonMapper;
    private final LessonReservationMapper lessonReservationMapper;
    private final PayMapper payMapper;

    @Transactional(isolation = Isolation.READ_COMMITTED)
    public void saveLessonReservation(PaymentDto paymentDto) {
        try {
            // 1. 레슨 정보 조회
            Lesson lesson = lessonMapper.getLessonByNo(paymentDto.getLessonNo());
            LessonUpdateForm lessonUpdateForm = new LessonUpdateForm();
            lessonUpdateForm.setLessonNo(paymentDto.getLessonNo());
            lessonUpdateForm.setParticipant(lesson.getParticipant());

            if (lesson == null) {
                throw new RuntimeException("존재하지 않는 레슨입니다. LessonNo: " + paymentDto.getLessonNo());
            }

            if (paymentDto.getUserId() == null) {
                throw new RuntimeException("로그인 되지 않은 상태입니다. userId : " + paymentDto.getUserId());
            }

            log.info("레슨 예약 시도: {}", paymentDto);
            log.info("현재 참가자 수: {}", lesson.getParticipant());

            // 2. 참가자 수 초과 여부 확인
            if (lesson.getParticipant() >= 5) {
                throw new RuntimeException("예약 정원 마감. LessonNo: "
                        + lesson.getLessonNo() + ", Current participants: " + lesson.getParticipant());
            }

            // 3. 결제 정보 저장
            Payment payment = new Payment();
            payment.setId(paymentDto.getPaymentId());
            payment.setUserId(paymentDto.getUserId());
            payment.setStatus("결제완료");
            payment.setType("레슨");
            payment.setMethod("카드");
            payment.setAmount(1);
            payment.setPrice(paymentDto.getTotalAmount());
            log.info("결제 정보 저장 Payment = {}", payment);
            payMapper.insertPay(payment);

            LessonReservation lessonReservation = new LessonReservation();
            User user = new User();
            user.setId(paymentDto.getUserId());
            lessonReservation.setUser(user);
            lessonReservation.setPayment(payment);
            lessonReservation.setLesson(lesson);

            // 4. 예약 정보 저장
            lessonReservationMapper.insertLessonReservation(lessonReservation);

            // 5. 참가자 수 업데이트
            lessonUpdateForm.setParticipant(lesson.getParticipant() + 1);
            if (lessonUpdateForm.getParticipant() == 5) {
                lessonUpdateForm.setStatus("마감");
                lessonMapper.updateLessonStatus(lessonUpdateForm);
            }
            log.info("참가자 수 업데이트 할 lesson = {}", lesson);
            log.info("참가자 수 업데이트 할 lessonUpdateForm = {}", lessonUpdateForm);
            lessonMapper.updateLessonParticipant(lessonUpdateForm); // 업데이트 후 커밋

            log.info("레슨 예약 저장 완료: {}", paymentDto);
        } catch (Exception e) {
            throw new RuntimeException(e);

        }
    }

    public LessonReservation getLessonReservationByPayId(String payId) {
        return lessonReservationMapper.getLessonReservationByPayId(payId);
    }

    public LessonReservation getLessonReservationByNo(int reservationNo) {
        return lessonReservationMapper.getLessonReservationByNo(reservationNo);
    }

    public List<LessonReservation> searchLessonReservationList(ReservationSearchCondition condition, String userId) {
        // 기본 날짜 포맷 정의
        DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyy-MM-dd");

        // startDate와 endDate 초기화 및 기본값 설정
        if (condition.getStart() == null) {
            condition.setStart(LocalDate.now().minusMonths(1)); // 기본값: 한 달 전
        }

        if (condition.getEnd() == null) {
            condition.setEnd(LocalDate.parse(condition.getEndDate(), formatter));
        }

        log.info("condition.getStart() = {}", condition.getStart());
        log.info("condition.getEnd() = {}", condition.getEnd());
        log.info("시간 테스트 = {}", LocalDateTime.now());

        // MyBatis 매퍼 호출
        return lessonReservationMapper.getReservationByCondition(condition, userId);
    }

    // 예약 상태 변경
    public void cancelReservation(String paymentId, ReservationStatus status, int lessonNo) {

        // 예약 상태 "취소"로 변경
        lessonReservationMapper.updateReservationStatus(paymentId, status.label());

        // 레슨 예약 인원 감소
        Lesson lesson = lessonService.getLessonByNo(lessonNo);
        LessonUpdateForm lessonUpdateForm = new LessonUpdateForm();
        lessonUpdateForm.setLessonNo(lessonNo);
        int participant = lesson.getParticipant();
        lessonUpdateForm.setParticipant(lesson.getParticipant() - 1);
        if (participant == 5) {
            lessonUpdateForm.setStatus(LessonStatus.RECRUITMENT.label());
            lessonMapper.updateLessonStatus(lessonUpdateForm);
        }

        lessonMapper.updateLessonParticipant(lessonUpdateForm);

        log.info("status.label() = {}", status.label());
    }

    public void completeReservation() {
        lessonReservationMapper.updatePastReservationStatus();
    }

}
