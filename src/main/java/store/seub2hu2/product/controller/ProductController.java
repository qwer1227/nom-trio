package store.seub2hu2.product.controller;

import lombok.extern.slf4j.Slf4j;
import okhttp3.Response;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.util.StringUtils;
import org.springframework.web.bind.annotation.*;
import store.seub2hu2.course.service.ReviewService;
import store.seub2hu2.product.dto.*;
import store.seub2hu2.product.mapper.ProdReviewMapper;
import store.seub2hu2.product.service.ProdReviewService;
import store.seub2hu2.product.service.ProductService;
import store.seub2hu2.product.vo.ProdReview;
import store.seub2hu2.security.user.LoginUser;
import store.seub2hu2.user.service.UserService;
import store.seub2hu2.user.vo.User;
import store.seub2hu2.util.ListDto;


import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Slf4j
@Controller
@RequestMapping("/product")
public class ProductController {

    @Autowired
    private ProductService productService;

    @Autowired
    private UserService userService;


    @Autowired
    private ProdReviewService prodReviewService;


    //  상품 전체 페이지 이동
    @GetMapping("/list")
    public String list(@RequestParam(name= "topNo") int topNo,
                       @RequestParam(name = "catNo", required = false, defaultValue = "0") int catNo,
                       @RequestParam(name = "page", required = false, defaultValue = "1") int page,
                       @RequestParam(name = "rows", required = false, defaultValue = "6") int rows,
                       @RequestParam(name = "sort" , required = false, defaultValue = "date") String sort,
                       @RequestParam(name = "opt", required = false) String opt,
                       @RequestParam(name = "value", required = false) String value,
                       Model model) {

        Map<String, Object> condition = new HashMap<>();
        condition.put("topNo", topNo);
        if(catNo != 0) {
            condition.put("catNo", catNo);
        }

        condition.put("page", page);
        condition.put("rows", rows);
        condition.put("sort", sort);
        if(StringUtils.hasText(opt) && StringUtils.hasText(value)) {
            condition.put("opt", opt);
            condition.put("value", value);
        }

        ListDto<ProdListDto> dto = productService.getProducts(condition);
        model.addAttribute("topNo", topNo);
        model.addAttribute("catNo", catNo);
        model.addAttribute("products", dto.getData());
        model.addAttribute("paging", dto.getPaging());

        return "product/list";
    }

    // 상품 상세 페이지 이동
    @GetMapping("/detail")
    public String detail(@RequestParam("no") int no,
                         @RequestParam("colorNo") int colorNo,
                         @AuthenticationPrincipal LoginUser loginUser,
                         Model model) {


        // 로그인 상태 확인 후 처리
        User user = null;
        if (loginUser != null) {
            user = userService.findbyUserId(loginUser.getId());
            model.addAttribute("user", user); // 로그인된 사용자 정보
        } else {
            model.addAttribute("user", null); // 비회원인 경우 null 전달
        }

        ProdDetailDto prodDetailDto = productService.getProductByNo(no);
        model.addAttribute("prodDetailDto", prodDetailDto);

        List<ColorProdImgDto> colorProdImgDto = productService.getProdImgByColorNo(no);
        model.addAttribute("colorProdImgDto", colorProdImgDto);

        SizeAmountDto sizeAmountDto = productService.getSizeAmountByColorNo(colorNo);
        model.addAttribute("sizeAmountDto", sizeAmountDto);

        ProdImagesDto prodImagesDto = productService.getProdImagesByColorNo(colorNo);
        model.addAttribute("prodImagesDto", prodImagesDto);


        List<ProdReviewDto> prodReviews = prodReviewService.getProdReviews(no);
        model.addAttribute("prodReviews", prodReviews);

        return "product/detail";
    }

    @GetMapping("/hit")
    public String hit(@RequestParam("no") int prodNo, @RequestParam("colorNo") int colorNo){
        productService.updateProdDetailViewCnt(prodNo, colorNo);

        return "redirect:detail?no=" + prodNo +"&colorNo="+colorNo;
    }


    @PostMapping("/addProdReview")
    public ResponseEntity<?> addReview(@ModelAttribute ProdReviewForm form
                                       ,@AuthenticationPrincipal LoginUser loginUser
                                        ,Model model) {

        ProdReviewDto dto = prodReviewService.addProdReview(form, loginUser.getNo());
        return ResponseEntity.ok(dto);
    }

    @GetMapping("reviews/{reviewNo}")
    public ResponseEntity<ProdReview> getReview(@PathVariable("reviewNo") int reviewNo) {
        ProdReview review = prodReviewService.getProdReviewByNo(reviewNo);
        if (review != null) {
            return ResponseEntity.ok(review);
        } else {
            return ResponseEntity.status(HttpStatus.NOT_FOUND).build();
        }
    }

    @PostMapping("reviews/edit")
    public ResponseEntity<String> editReview(@ModelAttribute ProdReview prodReview
                                            ,@AuthenticationPrincipal LoginUser loginUser) {



        try {
            int loggedUserNo = loginUser.getNo();

            if(prodReview.getUserNo() != loggedUserNo) {
                return ResponseEntity.status(HttpStatus.FORBIDDEN).body("자신의 리뷰만 수정할 수 있습니다.");
            }

            prodReviewService.updateProdReview(prodReview);
            return ResponseEntity.ok("리뷰 수정이 완료되었습니다.");
        } catch (Exception ex) {
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body("리뷰 수정 중 오류 발생");
        }
    }

    @PostMapping("review/delete/{reviewNo}")
    @ResponseBody
    public Map<String, Object> deleteReview(@PathVariable("reviewNo") int reviewNo
                                                , @AuthenticationPrincipal LoginUser loginUser ) {

        Map<String, Object> response = new HashMap<>();

        try {
            // 로그인한 사용자의 userNo 가져오기
            int loggedInUserNo = loginUser.getNo();

            // 리뷰 작성자의 userNo 조회
            ProdReview review = prodReviewService.getProdReviewByNo(reviewNo);

            if (review == null) {
                response.put("success", false);
                response.put("message", "해당 리뷰가 존재하지 않습니다.");
                return response;
            }

            // 로그인한 사용자와 리뷰 작성자 비교
            if (review.getUserNo() != loggedInUserNo) {
                response.put("success", false);
                response.put("message", "권한이 없습니다. 본인이 작성한 리뷰만 삭제할 수 있습니다.");
                return response;
            }

            // 삭제 처리
            boolean isDeleted = prodReviewService.deleteProdReview(reviewNo);
            response.put("success", isDeleted);

            if (isDeleted) {
                response.put("message", "리뷰가 성공적으로 삭제되었습니다.");
            } else {
                response.put("message", "리뷰 삭제에 실패했습니다.");
            }

        } catch (Exception ex) {
            response.put("success", false);
            response.put("message", "서버 오류가 발생했습니다.");
            ex.printStackTrace();
        }

        return response;
    }
}
