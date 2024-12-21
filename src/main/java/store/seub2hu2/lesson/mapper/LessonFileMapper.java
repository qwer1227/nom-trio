package store.seub2hu2.lesson.mapper;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;
import store.seub2hu2.lesson.vo.LessonFile;

import java.util.List;

@Mapper
public interface LessonFileMapper {
    void insertLessonFile(@Param("lessonFile") LessonFile file);

    List<LessonFile> getLessonFiles(@Param("lessonNo") int lessonNo);

    List<LessonFile> getImagesByLessonNo(@Param("lessonNo") int lessonNo);

    int lastInsertedLessonNo();

    void updateLessonFile(@Param("lessonFile") LessonFile file);

}
