package store.seub2hu2.order.mapper;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;
import store.seub2hu2.cart.dto.CartItemDto;
import store.seub2hu2.mypage.dto.*;
import store.seub2hu2.order.vo.Order;
import store.seub2hu2.order.vo.OrderItem;

import java.util.List;

@Mapper
public interface OrderMapper {

    // 주문 정보 저장
    void insertOrders(@Param("order") Order order);

    // 주문 상품 저장
    void insertOrderItems(@Param("orderItems") List<OrderItem> orderItems);


    // 장바구니에서 넘어간 상품들 조회
    List<CartItemDto> getOrderItemBySizeNo(@Param("sizeNoList") List<Integer> sizeNoList, @Param("userNo") int userNo);

    List<OrderResponse> getOrders(@Param("userNo") int userNo);

    ResponseDTO getOrderDetails(@Param("orderNo") int orderNo);

    // 주문 정보 조회
    OrderResultDto getOrderResult(@Param("orderNo") int orderNo);

    // 주문상품 
    List<OrderResultDto> getOrderResultItems(@Param("orderNo") int orderNo);
    
    int updateOrder(@Param("order") OrdersDTO order);

    void updateOrderStatus(@Param("order") Order order);
}
