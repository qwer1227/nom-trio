package store.seub2hu2.community.mapper;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;
import store.seub2hu2.community.vo.Marathon;
import store.seub2hu2.community.vo.MarathonOrgan;

import java.util.List;
import java.util.Map;

@Mapper
public interface MarathonMapper {

    void insertMarathon(@Param("marathon") Marathon marathon);
    void insertMarathonOrgan(@Param("organ") MarathonOrgan organ);
    List<Marathon> getMarathons(@Param("condition") Map<String, Object> condition);
    List<Marathon> getMarathonTopFive(@Param("condition") Map<String, Object> condition);
    int getTotalMarathons(@Param("condition") Map<String, Object> condition);
    Marathon getMarathonDetailByNo(@Param("no") int marathonNo);
    List<MarathonOrgan> getMarathonOrganDetailByNo(@Param("no") int marathonNo);
    void updateMarathonCnt(@Param("marathon") Marathon marathon);

    void updateMarathon(@Param("marathon") Marathon marathon);
    void deleteMarathonOrgan(@Param("no") int marathonNo);
}
