package store.seub2hu2.address.controller;

import lombok.RequiredArgsConstructor;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import store.seub2hu2.address.service.AddressService;
import store.seub2hu2.security.user.LoginUser;
import store.seub2hu2.user.service.UserService;
import store.seub2hu2.user.vo.Addr;
import store.seub2hu2.user.vo.User;  // 로그인한 유저 정보

import java.util.List;

@Controller
@RequiredArgsConstructor
@RequestMapping("/address")
public class AddressController {
    private final AddressService addressService;
    private final UserService userService;


    // 주소 삭제
    @PostMapping("/delete")
    public String deleteAddress(@RequestParam("addrNo") int addrNo, @AuthenticationPrincipal LoginUser loginuser) {
        Addr addr = (Addr) userService.findAddrByUserNo(addrNo);
        if (addr != null && addr.getUserNo() == loginuser.getNo()) {
            addressService.deleteAddress(addrNo);
            return "redirect:/address/list"; // 삭제 후 다시 목록 조회
        }
        return "error"; // 권한 없으면 에러 처리
    }

    // 주소 수정
    @PostMapping("/update")
    public String updateAddress(@ModelAttribute Addr addr, @AuthenticationPrincipal LoginUser loginuser) {
        if (addr.getUserNo() == loginuser.getNo()) {
            addressService.updateAddress(addr);
            return "redirect:/address/list"; // 수정 후 다시 목록 조회
        }
        return "error"; // 권한 없으면 에러 처리
    }
}
