package store.seub2hu2.mypage.controller;

import lombok.RequiredArgsConstructor;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import store.seub2hu2.mypage.dto.QnaCreateRequest;
import store.seub2hu2.mypage.dto.QnaResponse;
import store.seub2hu2.mypage.service.QnaService;
import store.seub2hu2.security.user.LoginUser;

@Controller
@RequestMapping("/mypage")
@RequiredArgsConstructor
public class MyPageQnaController {

    private final QnaService qnaService;

    // 문의내역 상세화면으로 간다
    @GetMapping("/qna/detail/{qnaNo}")
    public String qnaDetail(@PathVariable("qnaNo") int qnaNo, Model model){

        QnaResponse qnaResponse = qnaService.getQnaByQnaNo(qnaNo);

        model.addAttribute("qna", qnaResponse);

        return "mypage/qnadetail";
    }

    // 문의작성 화면으로 간다
    @GetMapping("/qna/create")
    public String getQnaCreate(Model model){

        model.addAttribute("isPosting",true);

        return "mypage/qnaform";
    }

    // 문의작성 기능 POST
    @PostMapping("/qna/create")
    public String postQnaCreate(@ModelAttribute QnaCreateRequest qnaCreateRequest, @AuthenticationPrincipal LoginUser loginUser){

        qnaService.insertQna(qnaCreateRequest,loginUser.getNo());

        return "redirect:/mypage/qna";
    }

    // 문의삭제 기능 POST
    @PostMapping("/qna/delete/{qnaNo}")
    public String postQnaDelete(@PathVariable("qnaNo") int qnaNo, @AuthenticationPrincipal LoginUser loginUser){

        String userName = loginUser.getNickname();

        boolean isAdmin = "관리자".equals(userName);

        qnaService.deleteQna(qnaNo);

        // 역할에 따른 리다이렉트 분류
        if(isAdmin){
            return "redirect:/admin/qna";
        } else {
            return "redirect:/mypage/qna";
        }
    }

    // 문의수정 화면
    @GetMapping("/qna/update/{qnaNo}")
    public String getQnaUpdate(Model model, @PathVariable("qnaNo") int qnaNo){

        QnaResponse qnaResponse = qnaService.getQnaByQnaNo(qnaNo);

        model.addAttribute("qna",qnaResponse);
        model.addAttribute("isUpdating", true);

        return "mypage/qnaform";
    }

    // 문의수정 기능
    @PostMapping("/qna/update/{qnaNo}")
    public String postQnaUpdate(@PathVariable("qnaNo") int qnaNo, @ModelAttribute QnaCreateRequest qnaCreateRequest){

        qnaService.updateQna(qnaCreateRequest,qnaNo);

        return "redirect:/mypage/qna";
    }
}
