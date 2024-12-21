package store.seub2hu2.product.dto;


import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import lombok.ToString;
import store.seub2hu2.product.vo.Color;
import store.seub2hu2.product.vo.Image;

import java.util.List;

@NoArgsConstructor
@ToString
@Setter
@Getter
public class ProdImagesDto {

    private int no; // 상품 번호
    private String name; // 상품 이름
    private Color color; // 색상 객체
    private List<Image> images; // 이미지 URL들
}
