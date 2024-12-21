package store.seub2hu2.mypage.controller;

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
import store.seub2hu2.admin.dto.RequestParamsDto;
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
import store.seub2hu2.order.vo.Order;
import store.seub2hu2.product.vo.Color;
import store.seub2hu2.product.vo.Product;
import store.seub2hu2.product.vo.Size;
import store.seub2hu2.security.user.LoginUser;
import store.seub2hu2.user.service.UserService;
import store.seub2hu2.user.vo.Addr;
import store.seub2hu2.user.vo.User;
import store.seub2hu2.user.vo.UserImage;
import store.seub2hu2.util.ListDto;
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
public class MyPageController {

    @Value("upload.directory.userImage")
    private String saveDirectory;

    @Autowired
    AddressService addressService;

    @Autowired
    PostService postService;

    @Autowired
    CartService cartService;

    @Autowired
    UserService userService;

    @Autowired
    OrderService orderService;

    @Autowired
    BoardService boardService;

    @Autowired
    WorkoutService workoutService;

    @Autowired
    private PasswordEncoder passwordEncoder;

    @Autowired
    private ReplyService replyService;

    @Autowired
    private ScrapService scrapService;

    @Autowired
    private ReportService reportService;

    @Autowired
    private QnaService qnaService;

    @Autowired
    private FileDownloadView fileDownloadView;

    @Autowired
    private CrewService crewService;

    @Autowired
    private WishListService wishListService;

    // URL localhost/mypage 입력 시 유저의 No를 활용해 그 유저의 페이지를 보여줌
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

    @GetMapping("/private")
    public String mypagePrivate(Model model, @AuthenticationPrincipal LoginUser loginUser){

        String userId = loginUser.getId();

        model.addAttribute("userId", userId);

        return "mypage/privatepage";
    }

    // 내 정보 수정전에 비밀번호 검증
    @GetMapping("/verify-password")
    public String verifyPassword(){
        return "mypage/verify-password";
    }

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


    // 내 정보 수정 폼
    @GetMapping("/edit")
    public String userEdit(Model model, @AuthenticationPrincipal LoginUser loginUser){

        List<Addr> addr = userService.findAddrByUserNo(loginUser.getNo());

        model.addAttribute("addr", addr);

        return "mypage/edit";
    }

    // 수정 폼 입력값 저장
    @PostMapping("/edit")
    public String userEdit(@ModelAttribute UserInfoReq userInfoReq,@AuthenticationPrincipal LoginUser loginUser){

        int isUpdated = userService.updateUser(userInfoReq,loginUser);

        if(isUpdated == 0){
            return "redirect:/mypage/private";
        } else if(isUpdated == 1){
            return "redirect:/mypage/edit?error1";
        } else {
            return "redirect:/mypage/edit?error2";
        }
    }

    @GetMapping("/history")
    public String userHistory(@RequestParam(name = "page", required = false, defaultValue = "1") int page
            , @RequestParam(name = "rows", required = false, defaultValue = "10") int rows
            , @RequestParam(name = "sort", required = false, defaultValue = "date") String sort
            , @RequestParam(name = "opt", required = false) String opt
            , @RequestParam(name = "keyword", required = false) String keyword
            , @RequestParam(name = "category", required = false) String category
            , @RequestParam(name = "type", required = false) String type
            , Model model, @AuthenticationPrincipal  LoginUser loginUser) {


        Map<String, Object> condition = new HashMap<>();
        condition.put("page", page);
        condition.put("rows", rows);
        condition.put("sort", sort);
        // 내가 쓴글보기 데이터
        condition.put("userNo", loginUser.getNo());
        condition.put("type" , type);

        // 카테고리 필터링 처리
        if (StringUtils.hasText(category)) {
            condition.put("category", category);
        }

        if (StringUtils.hasText(keyword)){
            condition.put("opt", opt);
            condition.put("keyword", keyword);
        }

        ListDto<Board> dto = boardService.getHistoryBoards(condition);

        model.addAttribute("boards", dto.getData());
        model.addAttribute("paging", dto.getPaging());
        return "mypage/history";
    }

    @GetMapping("/detail")
    public String detail(@RequestParam("no") int boardNo
            , @AuthenticationPrincipal LoginUser loginUser
            , Model model) {
        Board board = boardService.getBoardDetail(boardNo);
        List<Reply> replyList = replyService.getReplies(boardNo);
        board.setReply(replyList);
        int replyCnt = replyService.getReplyCnt(boardNo);

        if (loginUser != null) {
            int boardResult = boardService.getCheckLike(boardNo, loginUser);
            model.addAttribute("boardLiked", boardResult);

            int scrapResult = scrapService.getCheckScrap(boardNo, loginUser);
            model.addAttribute("Scrapped", scrapResult);

            for (Reply reply : replyList) {
                int replyResult = replyService.getCheckLike(reply.getNo(), "board", loginUser);

                model.addAttribute("replyLiked", replyResult);
            }
        }

        model.addAttribute("board", board);
        model.addAttribute("replies", replyList);
        model.addAttribute("replyCnt", replyCnt);

        return "community/detail";
    }

    @GetMapping("/form")
    public String form() {
        return "community/form";
    }

    @PostMapping("/register")
//    @PreAuthorize("isAuthenticated()")
    public String register(BoardForm form
            , @AuthenticationPrincipal LoginUser loginUser) {
        Board board = boardService.addNewBoard(form, loginUser);

        return "redirect:detail?no=" + board.getNo();
    }

    @GetMapping("/modify")
    public String modifyForm(@RequestParam("no") Integer boardNo
            , @AuthenticationPrincipal LoginUser loginUser
            , Model model) {
        Board board = boardService.getBoardDetail(boardNo);

        model.addAttribute("board", board);

        return "community/modify";
    }

    @PostMapping("/modify")
    public String update(BoardForm form
            , @AuthenticationPrincipal LoginUser loginUser) {
        boardService.updateBoard(form, loginUser);
        return "redirect:detail?no=" + form.getNo();
    }

    @GetMapping("/delete")
    public String delete(@RequestParam("no") int boardNo) {
        BoardForm form = new BoardForm();
        form.setNo(boardNo);
        boardService.deleteBoard(boardNo);
        return "redirect:main";
    }

    @GetMapping("/delete-file")
    public String deleteUploadFile(@RequestParam("no") int boardNo
            , @RequestParam("fileNo") int fileNo) {
        boardService.deleteBoardFile(boardNo, fileNo);

        return "redirect:modify?no=" + boardNo;
    }

    // 요청 URL : comm/filedown?no=xxx
    @GetMapping("/filedown")
    public ModelAndView download(@RequestParam("no") int boardNo
            , @AuthenticationPrincipal LoginUser loginUser) {
        Board board = boardService.getBoardDetail(boardNo);

        ModelAndView mav = new ModelAndView();

        mav.setView(fileDownloadView);
        mav.addObject("directory", saveDirectory);
        mav.addObject("filename", board.getUploadFile().getSaveName());
        mav.addObject("originalFilename", board.getOriginalFileName());

        return mav;
    }

    @GetMapping("/download")
    public ResponseEntity<Resource> downloadFile(int boardNo
            , @AuthenticationPrincipal LoginUser loginUser) throws Exception{
        Board board = boardService.getBoardDetail(boardNo);

        String fileName = board.getUploadFile().getSaveName();
        String originalFileName = board.getOriginalFileName();
        originalFileName = URLEncoder.encode(originalFileName, "UTF-8");

        File file = new File(new File(saveDirectory), fileName);
        FileSystemResource resource = new FileSystemResource(file);

        return ResponseEntity.ok()
                .header(HttpHeaders.CONTENT_DISPOSITION, "attachment; filename=" + originalFileName)
                .body(resource);
    }

    @GetMapping("/login")
    public String login(){
        return "redirect:/user/login";
    }
    @GetMapping("/add-reply")
    @PreAuthorize("isAuthenticated()")
    public String addReply(ReplyForm form
            , @AuthenticationPrincipal LoginUser loginUser) {

        replyService.addNewReply(form, loginUser);

        return "redirect:detail?no=" + form.getBoardNo();
    }

    @PostMapping("/add-comment")
    @PreAuthorize("isAuthenticated()")
    public String addComment(ReplyForm form
            , @AuthenticationPrincipal LoginUser loginUser){
        replyService.addNewComment(form, loginUser);

        return "redirect:detail?no=" + form.getBoardNo();
    }

    @PostMapping("/modify-reply")
    @PreAuthorize("isAuthenticated()")
    public String modifyReply(@RequestParam("replyNo") int replyNo
            , @RequestParam("boardNo") int boardNo
            , @RequestParam("content") String replyContent
            , @AuthenticationPrincipal LoginUser loginUser){
        ReplyForm form = new ReplyForm();
        form.setId(replyNo);
        form.setBoardNo(boardNo);
        form.setContent(replyContent);
        form.setUserNo(loginUser.getNo());

        replyService.updateReply(form, loginUser);

        return "redirect:detail?no=" + form.getBoardNo();
    }

    @GetMapping("/delete-reply")
    @PreAuthorize("isAuthenticated()")
    public String deleteReply(@RequestParam("rno") int replyNo,
                              @RequestParam("bno") int boardNo){
        ReplyForm form = new ReplyForm();
        form.setId(replyNo);
        form.setBoardNo(boardNo);
        replyService.deleteReply(replyNo);

        return "redirect:detail?no=" + form.getBoardNo();
    }

    @GetMapping("/update-board-like")
    public String updateBoardLike(@RequestParam("no") int boardNo
            , @AuthenticationPrincipal LoginUser loginUser){
        boardService.updateBoardLike(boardNo, loginUser);
        return "redirect:detail?no=" + boardNo;
    }

    @GetMapping("/delete-board-like")
    public String updateBoardUnlike(@RequestParam("no") int boardNo
            , @AuthenticationPrincipal LoginUser loginUser){
        boardService.deleteBoardLike(boardNo, loginUser);
        return "redirect:detail?no=" + boardNo;
    }

    @GetMapping("/update-reply-like")
    public String updateReplyLke(@RequestParam("no") int boardNo
            , @RequestParam("rno") int replyNo
            , @AuthenticationPrincipal LoginUser loginUser){

        replyService.updateReplyLike(replyNo, "reply", loginUser);
        return "redirect:detail?no=" + boardNo;
    }

    @GetMapping("/delete-reply-like")
    public String updateReplyUnlike(@RequestParam("no") int boardNo
            , @RequestParam("rno") int replyNo
            , @AuthenticationPrincipal LoginUser loginUser){

        replyService.deleteReplyLike(replyNo, "reply", loginUser);
        return "redirect:detail?no=" + boardNo;
    }

    @GetMapping("/update-board-scrap")
    public String updateScrap(@RequestParam("no") int boardNo
            , @AuthenticationPrincipal LoginUser loginUser){

        scrapService.updateBoardScrap(boardNo, loginUser);
        return "redirect:detail?no=" + boardNo;
    }

    @GetMapping("/delete-board-scrap")
    public String deleteScrap(@RequestParam("no") int boardNo
            , @AuthenticationPrincipal LoginUser loginUser){

        scrapService.deleteBoardScrap(boardNo, loginUser);
        return "redirect:detail?no=" + boardNo;
    }

    @PostMapping("/report-board")
    public String reportBoard(ReportForm form
            , @AuthenticationPrincipal LoginUser loginUser){

        reportService.registerReport(form, loginUser);
        return "redirect:detail?no=" + form.getNo();
    }

    @PostMapping("report-reply")
    public String reportReply(ReportForm form
            , @RequestParam("bno") int boardNo
            , @AuthenticationPrincipal LoginUser loginUser){

        reportService.registerReport(form, loginUser);
        return "redirect:detail?no=" + boardNo;
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

    @PostMapping("/delete")
    public String deleteItem(@RequestParam("cartNo") List<Integer> cartNoList) {

        cartService.deleteCartItems(cartNoList);

        return "redirect:/mypage/cart";
    }

    // Post 방식으로
    @PostMapping("/cart")
    public String addCart(@RequestParam("sizeNo") List<Integer> sizeNo
            , @RequestParam("prodNo") List<Integer> prodNo
            , @RequestParam("stock") List<Integer> stock
            , @RequestParam("colorNo") List<Integer> colorNo
            , @AuthenticationPrincipal LoginUser loginUser) {

        // CartRegisterForm
        List<CartRegisterForm> cartRegisterForms = new ArrayList<>();

        for (int i = 0; i < sizeNo.size(); i++) {
            int size = sizeNo.get(i);
            int prod = prodNo.get(i);
            int color = colorNo.get(i);
            int amount = stock.get(i);

            CartRegisterForm cartRegisterForm = new CartRegisterForm();
            cartRegisterForm.setSizeNo(size);
            cartRegisterForm.setProdNo(prod);
            cartRegisterForm.setColorNo(color);
            cartRegisterForm.setStock(amount);

            User user = User.builder().no(loginUser.getNo()).build();
            cartRegisterForm.setUserNo(user.getNo());

            cartRegisterForms.add(cartRegisterForm);
        }

        cartService.addCart(cartRegisterForms);

        return "redirect:cart";
    }

    @PostMapping("/add-to-cart")
    @ResponseBody
    public String addToCart(@RequestParam("wishNo") int wishNo
                            ,@RequestParam("prodNo") int prodNo
                            ,@RequestParam("colorNo") int colorNo
                            ,@RequestParam("sizeNo") int sizeNo
                            ,@AuthenticationPrincipal LoginUser loginUser) {

        // 로그인된 사용자의 정보를 가져오기
        User user = User.builder().no(loginUser.getNo()).build();

        // 위시리스트에서 해당 상품을 찾고, 장바구니에 추가
        Cart cart = new Cart();
        cart.setUser(user);

        // Product, Color, Size 세팅
        Product product = new Product();
        product.setNo(prodNo);
        cart.setProduct(product);

        Color color = new Color();
        color.setNo(colorNo);
        cart.setColor(color);

        Size size = new Size();
        size.setNo(sizeNo);
        cart.setSize(size);

        cartService.addToCart(cart);

        wishListService.deleteWishListItemByNo(wishNo);

        return "redirect:/cart";
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

    @PostMapping("/delete-wish")
    @ResponseBody
    public String deleteWish(@RequestParam("wishNo") int wishNo) {

        // 삭제
        wishListService.deleteWishListItemByNo(wishNo);
        return "삭제 성공";
    }

    // Post 방식으로
    @PostMapping("/wish")
    public String addWish(@RequestParam("sizeNo") List<Integer> sizeNo
                            ,@RequestParam("prodNo") List<Integer> prodNo
                            ,@RequestParam("colorNo") List<Integer> colorNo
                            ,@AuthenticationPrincipal LoginUser loginUser
                            , Model model){

        List<WishList> wishLists = new ArrayList<>();

        for (int i = 0; i < sizeNo.size(); i++) {
            WishList wish = new WishList();

            // Product 설정
            Product product = new Product();
            product.setNo(prodNo.get(i));
            wish.setProduct(product);

            // Color 설정
            Color color = new Color();
            color.setNo(colorNo.get(i));
            wish.setColor(color);

            // Size 설정
            Size size = new Size();
            size.setNo(sizeNo.get(i));
            wish.setSize(size);

            // User 설정
            User user = User.builder().no(loginUser.getNo()).build();
            wish.setUser(user);

            // WishList에 추가
            wishLists.add(wish);
        }

        // Service로 데이터 전달
        wishListService.insertWishItems(wishLists);

        return "redirect:wish";
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

    // 주문내역-상세 화면으로 간다
    @GetMapping("/orderhistorydetail/{orderNo}")
    public String orderHistoryDetail(@PathVariable("orderNo") int orderNo, Model model, @AuthenticationPrincipal LoginUser loginUser) {

        ResponseDTO order = orderService.getOrderDetails(orderNo);

        double totalPrice = order.getOrders().getOrderPrice()-order.getOrders().getDisPrice();

        model.addAttribute("order", order);
        model.addAttribute("totalPrice", totalPrice);

        return "mypage/orderhistorydetail";
    }

    // 주문결제 화면으로 간다.
    @GetMapping("/order")
    public String order() {

        return "mypage/order";
    }

    // Post 방식으로 주문결제 화면으로 간다.
    @PostMapping("/order")
    public String addOrder(@RequestParam("sizeNo") List<Integer> sizeNoList
            ,@RequestParam("stock") List<Integer> stock
            , @AuthenticationPrincipal LoginUser loginUser
            ,Model model) {

        List<CartItemDto> orderItems = orderService.getOrderItemBySizeNo(sizeNoList, stock, loginUser.getNo());
        model.addAttribute("orderItems", orderItems);

        List<Addr> addresses = addressService.getAddressListByUserNo(loginUser.getNo());
        model.addAttribute("addresses", addresses);

        return "mypage/order";
    }

    // 주문 완료 화면
//    @GetMapping("/order-pay-completed")
//    public String showOrderCompletionPage(Model model) {
//
//        int orderNo = 1001;
//        ResponseDTO responseDTO = orderService.getOrderDetails(orderNo);
//        model.addAttribute("orderDetail", responseDTO);
//
//        return "mypage/order-pay-completed";
//    }
    
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
