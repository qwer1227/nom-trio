package store.seub2hu2.community.vo;

import com.fasterxml.jackson.annotation.JsonFormat;
import lombok.*;
import store.seub2hu2.community.enums.BoardCategory;
import store.seub2hu2.user.vo.User;

import java.util.Date;
import java.util.List;

@NoArgsConstructor
@AllArgsConstructor
@Getter
@Setter
@ToString
public class Board {
    private int no;
    private int prevNo;
    private int nextNo;
    private String category;
    private User user;
    private String title;
    private String prevTitle;
    private String nextTitle;
    private String content;
    private UploadFile uploadFile;
    private Date createdDate;
    private Date updatedDate;
    private int viewCnt;
    private int scrapCnt;
    private int likeCnt;
    private String deleted;
    private String keep;
    private String reported;
    private List<Reply> reply;
    private int replyCnt;
    private int boardCnt;

    public String getOriginalFileName() {
        if(uploadFile == null){
            return null;
        }
        return uploadFile.getSaveName().substring(13);
    }
}
