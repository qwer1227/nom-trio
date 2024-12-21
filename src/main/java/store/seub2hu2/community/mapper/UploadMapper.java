package store.seub2hu2.community.mapper;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;
import store.seub2hu2.community.vo.UploadFile;

import java.util.List;

@Mapper
public interface UploadMapper {

    void insertBoardFile(@Param("uploadFile") UploadFile uploadFile);
    List<UploadFile> getBoardFiles();
    UploadFile getFileByBoardNo(int boardNo);
    void updateBoardFile(UploadFile uploadFile);

    void insertNoticeFile(@Param("uploadFile") UploadFile uploadFile);
    UploadFile getFileByNoticeNo(int noticeNo);
    void updateNoticeFile(UploadFile uploadFile);

    void insertCrewFile(@Param("uploadFile") UploadFile uploadFile);
    UploadFile getThumbnailByCrewNo(int crewNo);
    UploadFile getFileByCrewNo(int crewNo);
    void updateCrewFile(@Param("fileNo") int fileNo);
}
