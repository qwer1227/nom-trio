package store.seub2hu2.product.dto;

import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import lombok.ToString;
import store.seub2hu2.product.vo.Size;

import java.util.List;


@NoArgsConstructor
@ToString
@Setter
@Getter
public class SizeAmountDto {

    private int no; // 사이즈 번호
    private String name; // 사이즈 명(?)
    private List<Size> sizes; //사이즈별 사이즈
}
