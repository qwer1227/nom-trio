package store.seub2hu2.mypage.mapper;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;
import store.seub2hu2.mypage.dto.AnswerDTO;
import store.seub2hu2.mypage.dto.QnaCreateRequest;
import store.seub2hu2.mypage.dto.QnaResponse;
import store.seub2hu2.util.RequestParamsDto;

import java.util.List;

@Mapper
public interface QnaMapper {
    QnaResponse getQnaByQnaNo(@Param("qnaNo") int qnaNo);
    void insertQna(@Param("qna") QnaCreateRequest qnaCreateRequest);
    void deleteQna(@Param("qnaNo") int qnaNo);
    void updateQna(@Param("qnaNo") int qnaNo, @Param("qna") QnaCreateRequest qnaCreateRequest);
    int getTotalRows(@Param("req") RequestParamsDto requestParamsDto, @Param("admin") String adminName, @Param("userNo") int userNo);
    List<QnaResponse> getQnas(@Param("req") RequestParamsDto requestParamsDto, @Param("admin") String adminName, @Param("userNo") int userNo);
    void updateAnswer(@Param("answer")AnswerDTO answerDTO, @Param("userNo") int userNo);

}
