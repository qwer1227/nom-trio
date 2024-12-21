package store.seub2hu2.product.vo;

import lombok.*;

@AllArgsConstructor
@NoArgsConstructor
@Setter
@Getter
@ToString
public class Size {

    private int no;
    private String size;
    private int amount;
    private Color color;
    private String isDeleted;

}
