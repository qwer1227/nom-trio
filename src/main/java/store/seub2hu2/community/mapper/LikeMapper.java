package store.seub2hu2.community.mapper;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;
import store.seub2hu2.community.dto.FunctionCheckDto;

@Mapper
public interface LikeMapper {

    void insertLike(@Param("dto") FunctionCheckDto dto);
    void deleteLike(@Param("dto") FunctionCheckDto dto);
    int hasUserLiked(@Param("dto") FunctionCheckDto dto);
    int getLikeCnt(@Param("type") String type, @Param("no") int typeNo);
}
