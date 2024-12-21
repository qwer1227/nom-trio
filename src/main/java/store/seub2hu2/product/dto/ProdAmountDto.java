package store.seub2hu2.product.dto;

import lombok.*;

@ToString
@NoArgsConstructor
@AllArgsConstructor
@Setter
@Getter
public class ProdAmountDto {

    private int sizeNo;
    private String sizeName;
    private int prodAmount;
}
