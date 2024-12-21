package store.seub2hu2.message.vo;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

import java.util.Date;

@NoArgsConstructor
@AllArgsConstructor
@Getter
@Setter
public class MessageFile {
    private int fileNo;        // 파일 번호
    private int messageNo;     // 메시지 번호
    private String originalName; // 원본 파일명
    private String savedName;   // 저장된 파일명
    private String deleted;     // 삭제 여부 (예: "Y" 또는 "N")
    private String type;
    private long size;
    private Date createdDate;   // 파일 생성일
    private Date updatedDate;   // 파일 업데이트일
}
