package store.seub2hu2.product.vo;

import lombok.*;

@NoArgsConstructor
@AllArgsConstructor
@ToString
@Setter
@Getter
public class Image {

    private int no;
    private String url;
    private String isThum;
    private Product product;
    private int colorNo;
    private int prodNo;
}
