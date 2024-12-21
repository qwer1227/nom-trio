package store.seub2hu2.lesson.mapper;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;
import store.seub2hu2.lesson.enums.ReservationStatus;
import store.seub2hu2.lesson.vo.Lesson;
import store.seub2hu2.payment.dto.PaymentDto;
import store.seub2hu2.lesson.dto.ReservationSearchCondition;
import store.seub2hu2.lesson.vo.LessonReservation;

import java.util.List;

@Mapper
public interface LessonReservationMapper {

    // 레슨 예약 등록
    public void insertLessonReservation(@Param("lessonReservation") LessonReservation lessonReservation);

    // 회원 번호로 회원이 예약한 레슨 조회
    public List<LessonReservation> getLessonReservationByUserId (@Param("userId") String userId);

    // 예약한 레슨 조건 검색
    List<LessonReservation> getReservationByCondition(@Param("condition") ReservationSearchCondition condition, @Param("userId") String userId);

    // 결제번호로 결제한 예약 조회
    public LessonReservation getLessonReservationByPayId(@Param("payId") String payId);
    
    // 예약 번호로 예약 조회
    public LessonReservation getLessonReservationByNo (@Param("reservationNo") int reservationNo);

    // 예약 상태 변경
    public void updateReservationStatus (@Param("paymentId") String paymentId,  @Param("status") String status);

    // 지난 레슨 상태 변경
    public void updatePastReservationStatus();

}
