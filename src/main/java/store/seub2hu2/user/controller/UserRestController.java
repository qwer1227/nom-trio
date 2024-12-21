package store.seub2hu2.user.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import store.seub2hu2.user.service.UserService;

import java.util.Map;

@RestController
@RequestMapping("/api/users")
public class UserRestController {

    @Autowired
    private UserService userService;

    // 아이디 중복 검사
    @GetMapping("/check-id")
    public ResponseEntity<?> checkDuplicateId(@RequestParam("id") String id) {
        boolean isDuplicate = userService.checkDuplicateId(id);
        return ResponseEntity.ok().body(Map.of("duplicate", isDuplicate));
    }

    // 이메일 중복 검사
    @GetMapping("/check-email")
    public ResponseEntity<?> checkDuplicateEmail(@RequestParam("email") String email) {
        boolean isDuplicate = userService.checkDuplicateEmail(email);
        return ResponseEntity.ok().body(Map.of("duplicate", isDuplicate));
    }

    // 닉네임 중복 검사
    @GetMapping("/check-nickname")
    public ResponseEntity<?> checkDuplicateNickname(@RequestParam("nickname") String nickname) {
        boolean isDuplicate = userService.checkDuplicateNickname(nickname);
        return ResponseEntity.ok().body(Map.of("duplicate", isDuplicate));
    }

}
