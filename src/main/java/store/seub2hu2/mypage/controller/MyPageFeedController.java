package store.seub2hu2.mypage.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import store.seub2hu2.mypage.service.PostService;
import store.seub2hu2.mypage.vo.Post;
import store.seub2hu2.security.user.LoginUser;
import store.seub2hu2.user.service.UserService;
import store.seub2hu2.user.vo.User;
import store.seub2hu2.user.vo.UserImage;

import java.util.List;

@Controller
@RequestMapping("/mypage")
public class MyPageFeedController {

    @Autowired
    PostService postService;

    @Autowired
    UserService userService;

    @GetMapping("")
    public String myPageList(Model model, @AuthenticationPrincipal LoginUser loginUser, @RequestParam(value = "userName", required = false) String userName) {

        User user = null;
        UserImage userImage = null;
        List<Post> posts = null;
        boolean isOwnProfile = false;

        try {
            if (userName != null && !userName.isEmpty()) {
                // userName이 파라미터로 제공되면 해당 닉네임으로 사용자 정보를 조회
                user = userService.findByNickname(userName);
                userImage = userService.findImageByUserNo(user.getNo());
                posts = postService.getPostsByNo(user.getNo());
                isOwnProfile = (user.getNo() == loginUser.getNo());
            } else {
                posts = postService.getPostsByNo(loginUser.getNo());
                user = userService.findbyUserId(loginUser.getId());
                userImage = userService.findImageByUserNo(loginUser.getNo());
                isOwnProfile = true;

                System.out.println(posts);
            }
        } catch (Exception e){
            e.printStackTrace();
        }

        model.addAttribute("posts",posts);
        model.addAttribute("user",user);
        model.addAttribute("userimage",userImage);
        model.addAttribute("isOwnProfile", isOwnProfile);

        return "mypage/publicpage";
    }
}
