package store.seub2hu2.admin.dto;

import lombok.*;

@NoArgsConstructor
@AllArgsConstructor
@ToString
@Setter
@Getter
public class RequestParamsDto {
    private int page = 1; // 기본값
    private int rows = 10; // 기본값
    private String sort = "date"; // 기본값
    private String opt;
    private String keyword;
    private String category;
    private int begin;
    private int end;
}
