package store.seub2hu2.admin.dto;

import lombok.*;
import store.seub2hu2.product.vo.Color;
import store.seub2hu2.product.vo.Size;

@ToString
@NoArgsConstructor
@AllArgsConstructor
@Setter
@Getter
public class ProductStockForm {

    private Color color;
    private Size size;
}
