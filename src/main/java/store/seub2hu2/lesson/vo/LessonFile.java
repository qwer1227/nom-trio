package store.seub2hu2.lesson.vo;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

import java.util.Date;

@NoArgsConstructor
@AllArgsConstructor
@Getter
@Setter
public class LessonFile {
    private Integer fileId;
    private Integer lessonNo;
    private String fileName;
    private String fileType;
    private String filePath;
    private Date uploadDate;
    private String base64Data;

    public LessonFile(Integer lessonNo, String fileName, String fileType, String filePath) {
        this.lessonNo = lessonNo;
        this.fileName = fileName;
        this.fileType = fileType;
        this.filePath = filePath;
    }


    // Getters and setters
}
