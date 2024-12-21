package store.seub2hu2.delivery.mapper;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;
import store.seub2hu2.delivery.vo.Delivery;

@Mapper
public interface DeliveryMapper {

    // 배송 정보 저장
    void insertDeliveryMemo(@Param("delivery") Delivery delivery);

    // 배송 상태 변경
    void updateDeliveryStatus(@Param("delivery") Delivery delivery);
}
