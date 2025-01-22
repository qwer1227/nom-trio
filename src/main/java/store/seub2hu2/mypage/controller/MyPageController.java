package store.seub2hu2.mypage.controller;

import lombok.RequiredArgsConstructor;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.core.io.FileSystemResource;
import org.springframework.core.io.Resource;
import org.springframework.http.HttpHeaders;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.util.StringUtils;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.ModelAndView;
import store.seub2hu2.address.service.AddressService;
import store.seub2hu2.cart.dto.CartItemDto;
import store.seub2hu2.cart.dto.CartRegisterForm;
import store.seub2hu2.cart.vo.Cart;
import store.seub2hu2.community.dto.BoardForm;
import store.seub2hu2.community.dto.ReplyForm;
import store.seub2hu2.community.dto.ReportForm;
import store.seub2hu2.community.service.*;
import store.seub2hu2.community.vo.Board;
import store.seub2hu2.community.vo.Crew;
import store.seub2hu2.community.vo.Reply;
import store.seub2hu2.lesson.view.FileDownloadView;
import store.seub2hu2.mypage.dto.*;
import store.seub2hu2.mypage.service.*;
import store.seub2hu2.mypage.vo.Post;
import store.seub2hu2.order.service.OrderService;
import store.seub2hu2.product.vo.Color;
import store.seub2hu2.product.vo.Product;
import store.seub2hu2.product.vo.Size;
import store.seub2hu2.security.user.LoginUser;
import store.seub2hu2.user.service.UserService;
import store.seub2hu2.user.vo.Addr;
import store.seub2hu2.user.vo.User;
import store.seub2hu2.user.vo.UserImage;
import store.seub2hu2.util.ListDto;
import store.seub2hu2.util.RequestParamsDto;
import store.seub2hu2.wish.dto.WishItemDto;
import store.seub2hu2.wish.vo.WishList;

import java.io.File;
import java.net.URLEncoder;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Controller
@RequestMapping("/mypage")
@RequiredArgsConstructor
public class MyPageController {

    private final UserService userService;

    private final BoardService boardService;

    private final QnaService qnaService;

    private final CrewService crewService;

    private final CartService cartService;

    private final WishListService wishListService;

    private final OrderService orderService;

    // URL localhost/mypage 입력 시 유저의 No를 활용해 그 유저의 페이지를 보여줌

    @GetMapping("/private")
    public String mypagePrivate(Model model, @AuthenticationPrincipal LoginUser loginUser){

        String userId = loginUser.getId();

        model.addAttribute("userId", userId);

        return "mypage/privatepage";
    }

    // 내 정보 수정 폼
    @GetMapping("/edit")
    public String userEdit(Model model, @AuthenticationPrincipal LoginUser loginUser){

        List<Addr> addr = userService.findAddrByUserNo(loginUser.getNo());

        model.addAttribute("addr", addr);

        return "mypage/edit";
    }

    @GetMapping("/history")
    public String userHistory(@ModelAttribute RequestParamsDto requestParamsDto
            , Model model, @AuthenticationPrincipal  LoginUser loginUser) {

        ListDto<Board> dto = boardService.getHistoryBoards(requestParamsDto, loginUser.getNo());

        model.addAttribute("boards", dto.getData());
        model.addAttribute("paging", dto.getPaging());
        return "mypage/history";
    }

    // 위시리스트 화면으로 간다.
    @GetMapping("/wish")
    public String wish(@AuthenticationPrincipal LoginUser loginUser
            , Model model) {

        User user = User.builder().no(loginUser.getNo()).build();

        List<WishItemDto> wishItemDtoList = wishListService.getWishListByUserNo(user.getNo());

        model.addAttribute("wishItemDtoList",wishItemDtoList);

        return "mypage/wish";
    }

    // 장바구니 화면으로 간다.
    @GetMapping("/cart")
    public String cart(@AuthenticationPrincipal LoginUser loginUser
            , Model model) {
        User user = User.builder().no(loginUser.getNo()).build();

        List<CartItemDto> cartItemDtoList = cartService.getCartItemsByUserNo(user.getNo());

        model.addAttribute("cartItemDtoList",cartItemDtoList);
        model.addAttribute("qty", cartItemDtoList.size());

        return "mypage/cart";
    }

    // 주문내역 화면으로 간다.
    @GetMapping("/orderhistory")
    public String orderHistory(Model model, @AuthenticationPrincipal LoginUser loginUser) {

        // 주문내역 가져오기
        User user = User.builder().no(loginUser.getNo()).build();

        List<OrderResponse> orders = orderService.getAllOrders(user.getNo());

        model.addAttribute("orders", orders);

        return "mypage/orderhistory";
    }

    // 레슨예약내역 화면으로 간다
    @GetMapping("/reservation")
    public String reservation(){

        return "lesson/lesson-reservation";
    }

    // 문의내역 화면으로 간다
    @GetMapping("/qna")
    public String qna(Model model, @AuthenticationPrincipal LoginUser loginUser, RequestParamsDto requestParamsDto){

        ListDto<QnaResponse> qnaDto = qnaService.getQnas(requestParamsDto, loginUser.getNo());
        
        model.addAttribute("qna", qnaDto.getData());
        model.addAttribute("pagination", qnaDto.getPaging());

        return "mypage/qna";
    }


    // 운동일지 화면
    @GetMapping("/workout")
    public String workout(){

        return "mypage/workoutdiary";
    }

    // 참여크루 화면
    @GetMapping("/participatingcrew")
    public String crew(Model model, @AuthenticationPrincipal LoginUser loginUser){

        List<Crew> crews = crewService.getCrewByUserNo(loginUser.getNo());
        model.addAttribute("crews", crews);

        return "mypage/participatingcrew";
    }

}
