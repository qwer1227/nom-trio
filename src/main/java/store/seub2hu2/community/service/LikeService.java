package store.seub2hu2.community.service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.stereotype.Service;
import store.seub2hu2.community.dto.FunctionCheckDto;
import store.seub2hu2.community.mapper.LikeMapper;
import store.seub2hu2.security.user.LoginUser;

@Service
public class LikeService {

    @Autowired
    private LikeMapper likeMapper;

    public void insertLike(String type
                            , int typeNo
                            , @AuthenticationPrincipal LoginUser loginUser){

        FunctionCheckDto dto = new FunctionCheckDto();
        dto.setType(type);
        dto.setTypeNo(typeNo);
        dto.setUserNo(loginUser.getNo());

        likeMapper.insertLike(dto);
    }

    public void deleteLike(String type
                           , int typeNo
                           , @AuthenticationPrincipal LoginUser loginUser){
        FunctionCheckDto dto = new FunctionCheckDto();
        dto.setType(type);
        dto.setTypeNo(typeNo);
        dto.setUserNo(loginUser.getNo());

        likeMapper.deleteLike(dto);
    }

    public int getCheckLike(String type
                            , int typeNo
                            , @AuthenticationPrincipal LoginUser loginUser){
        FunctionCheckDto dto = new FunctionCheckDto();
        dto.setType(type);
        dto.setTypeNo(typeNo);
        dto.setUserNo(loginUser.getNo());

        int result = likeMapper.hasUserLiked(dto);

        return result;
    }

    public int getLikeCnt(String type, int typeNo){
        int result = likeMapper.getLikeCnt(type, typeNo);

        return result;
    }
}
