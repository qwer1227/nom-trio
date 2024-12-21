package store.seub2hu2.payment.mapper;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;
import store.seub2hu2.payment.vo.Payment;

@Mapper
public interface PayMapper {

    // 결제 정보 등록
    public void insertPay(@Param("pay") Payment payment);

    // tid로 결제 정보 조회
    public Payment getPaymentById(@Param("payId") String payId);

    // tid로 결제 타입(결제방식X, 레슨 or 상품) 조회
    public String getPaymentTypeById(@Param("payId") String payId);

    // 결제 상태 변경(레슨)
    public void updateLessonPayStatus();

    // 결제 상태 변경(상품)
    void updateProductPayStatus(@Param("pay") Payment payment);

}
