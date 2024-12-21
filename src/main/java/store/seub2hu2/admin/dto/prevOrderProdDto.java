package store.seub2hu2.admin.dto;

import lombok.*;

@ToString
@NoArgsConstructor
@AllArgsConstructor
@Setter
@Getter
public class prevOrderProdDto {

    private int payNo;
    private int orderNo;
    private String orderNum;
    private int orderProdNo;
    private String payType;
    private String userName;
    private String userId;
    private String userTel;
    private String payPrice;
    private int orderPrice;
    private String payStatus;
    private String payMethod;
    private String prodName;
    private int prodPrice;
    private String colorName;
    private String prodSize;
    private int orderProdAmount;
    private int orderDisPrice;
    private int orderRealPrice;
}
