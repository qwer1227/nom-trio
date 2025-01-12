package store.seub2hu2.community.dto;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@NoArgsConstructor
@AllArgsConstructor
@Data
public class FunctionCheckDto {

    private String type;
    private int typeNo;
    private int userNo;
}
