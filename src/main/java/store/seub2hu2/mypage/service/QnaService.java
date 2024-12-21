package store.seub2hu2.mypage.service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.parameters.P;
import org.springframework.stereotype.Service;
import org.springframework.util.StringUtils;
import store.seub2hu2.admin.dto.RequestParamsDto;
import store.seub2hu2.mypage.dto.AnswerDTO;
import store.seub2hu2.mypage.dto.QnaCreateRequest;
import store.seub2hu2.mypage.dto.QnaResponse;
import store.seub2hu2.mypage.mapper.QnaMapper;
import store.seub2hu2.security.user.LoginUser;
import store.seub2hu2.user.mapper.UserMapper;
import store.seub2hu2.user.vo.User;
import store.seub2hu2.util.ListDto;
import store.seub2hu2.util.Pagination;

import java.util.List;
import java.util.Map;

@Service
public class QnaService {

    @Autowired
    private QnaMapper qnaMapper;
    @Autowired
    private UserMapper userMapper;


    public QnaResponse getQnaByQnaNo(int qnaNo){

        QnaResponse qnaResponse = qnaMapper.getQnaByQnaNo(qnaNo);

        return qnaResponse;
    }

    public void insertQna(QnaCreateRequest qnaCreateRequest, int userNo){

        qnaCreateRequest.setQuestionUserNo(userNo);

        qnaMapper.insertQna(qnaCreateRequest);

    }

    public void deleteQna(int qnaNo){

        qnaMapper.deleteQna(qnaNo);
    }

    public void updateQna(QnaCreateRequest qnaCreateRequest, int qnaNo){

        qnaMapper.updateQna(qnaNo,qnaCreateRequest);
    }


    public ListDto<QnaResponse> getQnas(RequestParamsDto requestParamsDto, int userNo){

        // 검색 조건이 'status'일 때, keyword 값을 0, 1, 2로 변환
        if ("status".equals(requestParamsDto.getOpt()) && StringUtils.hasText(requestParamsDto.getKeyword())) {
            String status = requestParamsDto.getKeyword();
            // "대기", "완료", "삭제"를 0, 1, 2로 변환
            if ("대기".equals(status)) {
                requestParamsDto.setKeyword("0");
            } else if ("완료".equals(status)) {
                requestParamsDto.setKeyword("1");
            } else if ("삭제".equals(status)) {
                requestParamsDto.setKeyword("2");
            }
        }

        // 어드민 이름 가져오기
        User user = userMapper.findByUserNo(userNo);

        System.out.println("유저번호: " + userNo);
        System.out.println("유저:" + user);
        System.out.println("이름:" +user.getNickname());

        // 검색 조건에 맞는 전체 데이터 개수를 조회하는 기능
        int totalRows = qnaMapper.getTotalRows(requestParamsDto,user.getNickname(), userNo);

        // Pagination 객체를 생성한다
        int page = requestParamsDto.getPage();
        int rows = requestParamsDto.getRows();

        Pagination pagination = new Pagination(page, totalRows, rows);

        requestParamsDto.setBegin(pagination.getBegin());
        requestParamsDto.setEnd(pagination.getEnd());

        // ProdListDto 타입의 데이터를 담는 ListDto객체를 생성한다
        // 질문 목록 ListDto(QnaReponse), 페이징처리 정보(Pagination)을 담는다
        List<QnaResponse> qnas = qnaMapper.getQnas(requestParamsDto, user.getNickname(), userNo);
        System.out.println(qnas);
        ListDto<QnaResponse> dto = new ListDto<>(qnas,pagination);

        return dto;
    }

    public void updateAnswer(AnswerDTO answerDTO, int userNo){

        qnaMapper.updateAnswer(answerDTO,userNo);
    }
}
