package store.seub2hu2.mypage.controller;

import lombok.RequiredArgsConstructor;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.*;
import store.seub2hu2.mypage.dto.UserInfoReq;
import store.seub2hu2.security.user.LoginUser;
import store.seub2hu2.user.service.UserService;

@Controller
@RequestMapping("/mypage")
@RequiredArgsConstructor
public class MyPageEditController {

    private final UserService userService;

    // 검증 로직
    @PostMapping("/verify-password")
    public String verifyPassword(@RequestParam(name = "password") String password, @AuthenticationPrincipal LoginUser loginUser) {

        boolean isChecked = userService.verifyPassword(password,loginUser);

        if(isChecked) {
            // 비밀번호가 맞으면 페이지 변경
            return "redirect:/mypage/edit";
        }
        // 비밀번호가 틀리면 다시 입력하도록 에러 메시지 추가
        return "redirect:/mypage/verify-password?error";
    }

    // 내 정보 수정전에 비밀번호 검증
    @GetMapping("/verify-password")
    public String verifyPassword(){
        return "mypage/verify-password";
    }

    // 수정 폼 입력값 저장
    @PostMapping("/edit")
    public String userEdit(@ModelAttribute UserInfoReq userInfoReq, @AuthenticationPrincipal LoginUser loginUser){

        int isUpdated = userService.updateUser(userInfoReq,loginUser);

        if(isUpdated == 0){
            return "redirect:/mypage/private";
        } else if(isUpdated == 1){
            return "redirect:/mypage/edit?error1";
        } else {
            return "redirect:/mypage/edit?error2";
        }
    }
}
