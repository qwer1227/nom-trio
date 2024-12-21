package store.seub2hu2.community.mapper;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;
import store.seub2hu2.community.vo.Report;

@Mapper
public interface ReportMapper {

    void insertReport(@Param("report") Report report);

    void insertReportToCrew(@Param("report") Report report);
    boolean isAlreadyReported(@Param("type") String type, @Param("no") int no, @Param("userNo") int userNo);
}
