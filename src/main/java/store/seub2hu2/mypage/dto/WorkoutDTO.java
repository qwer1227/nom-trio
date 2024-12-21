package store.seub2hu2.mypage.dto;

import lombok.*;

import java.util.Date;

@NoArgsConstructor
@AllArgsConstructor
@ToString
@Getter
@Setter
public class WorkoutDTO {
    private int workNo;
    private String title;
    private String description;
    private Date startDate;
    private int userNo;
    private int categoryNo;
    private String categoryName;
}

