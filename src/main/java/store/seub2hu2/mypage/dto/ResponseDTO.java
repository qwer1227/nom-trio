package store.seub2hu2.mypage.dto;

import lombok.*;

import java.util.List;

@NoArgsConstructor
@AllArgsConstructor
@ToString
@Getter
@Setter
public class ResponseDTO {
    private int no;
    private PaymentsDTO payments;
    private ProductImgDTO productImg;
    private OrdersDTO orders;
    private List<ProductDTO> products;
    private ProductDTO product;
    private AddrDto addrDto;
    private DeliveryDto deliveryDto;

}
