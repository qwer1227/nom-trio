package store.seub2hu2.mypage.dto;

import lombok.*;

@NoArgsConstructor
@AllArgsConstructor
@ToString
@Getter
@Setter
public class ProductDTO {
    private int prodNo;
    private String prodName;
    private String sizeName;
    private int colorNo;
    private String colorName;
    private int orderQty;
    private int prodPrice;
    private String prodImgUrl;
    private String orderStatus;
}
