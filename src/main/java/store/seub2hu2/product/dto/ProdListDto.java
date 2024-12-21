package store.seub2hu2.product.dto;

import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import lombok.ToString;
import store.seub2hu2.product.vo.Brand;
import store.seub2hu2.product.vo.Category;
import store.seub2hu2.product.vo.Color;
import store.seub2hu2.product.vo.Image;

import java.util.Date;
import java.util.List;
import java.util.Map;

@NoArgsConstructor
@ToString
@Setter
@Getter
public class ProdListDto {

    private int no; // 상품 번호
    private String name; // 상품이름
    private int price; // 상품 가격
    private int colorNum; // 색상 대표 번호
    private String status; // 상품상태
    private Date createdAt; // 상품 등록 날짜
    private String imgThum; // 대표 이미지 URL
    private double rating;
    private Category category; // 카테고리 객체
    private Brand brand; // 브랜드 객체
    private Color color;
    private String isDeleted;
    private String isShow;
    private int rankChange; // 순위 변동
    private int cnt;

}
