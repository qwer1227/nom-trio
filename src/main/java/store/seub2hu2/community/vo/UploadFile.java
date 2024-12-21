package store.seub2hu2.community.vo;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

import java.util.Date;

@NoArgsConstructor
@AllArgsConstructor
@Getter
@Setter
public class UploadFile {
    private int fileNo;
    private int no;     // boardNo / noticeNo
    private String originalName;
    private String saveName;
    private String deleted;
    private Date createdDate;
    private Date updatedDate;
}
