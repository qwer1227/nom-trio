package store.seub2hu2.mypage.dto;

import lombok.*;

@ToString
@AllArgsConstructor
@NoArgsConstructor
@Setter
@Getter
public class OrderResultItemDto {

    private int orderProdNo; // 주문 상품 번호
    private int prodNo; // 상품 번호
    private String prodName; // 상품 이름
    private int colorNo; // 색상 번호
    private String prodColor; // 색상 이름
    private int sizeNo; // 사이즈 번호
    private String prodSize; // 사이즈
    private int orderNo; // 주문 번호
    private int orderProdAmount; // 각 삼품 개수
    private int orderUnitPrice; // 각 상품 가격
    private int orderEachPrice; // 각 상품 개수 * 각 상품 가격

}
