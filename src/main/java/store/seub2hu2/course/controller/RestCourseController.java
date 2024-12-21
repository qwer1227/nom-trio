package store.seub2hu2.course.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.web.bind.annotation.*;
import store.seub2hu2.course.dto.AddRecordForm;
import store.seub2hu2.course.dto.AddReviewForm;
import store.seub2hu2.course.exception.CourseReviewException;
import store.seub2hu2.course.service.ReviewService;
import store.seub2hu2.course.service.UserCourseService;
import store.seub2hu2.course.vo.Records;
import store.seub2hu2.course.vo.Review;
import store.seub2hu2.security.user.LoginUser;
import store.seub2hu2.security.dto.RestResponseDto;
import store.seub2hu2.util.ListDto;

import java.util.HashMap;
import java.util.Map;

@RestController
@RequestMapping("/ajax")
public class RestCourseController {
    @Autowired
    private ReviewService reviewService;

    @Autowired
    private UserCourseService userCourseService;

    @PreAuthorize("isAuthenticated()")
    @PostMapping("/addRecord")
    @ResponseBody
    public void addRecord(AddRecordForm form, @AuthenticationPrincipal LoginUser loginUser) {
        // 1. 코스 완주 기록을 저장한다.
        userCourseService.addNewRecord(form, loginUser.getNo());
    }

    @GetMapping("/reviews/{no}/{page}")
    public ResponseEntity<RestResponseDto<ListDto<Review>>> reviews(@PathVariable("no") int courseNo,
                                                                    @PathVariable("page") int page) {
        // 1. Map 객체에 코스 번호, 페이지를 저장한다.
        Map<String, Object> condition = new HashMap<>();
        condition.put("courseNo", courseNo);
        condition.put("page", page);

        // 2. 코스에 등록된 모든 리뷰를 가져온다.
        ListDto<Review> dto = reviewService.getReviews(condition);

        // 3. 응답 데이터를 반환한다.
        return ResponseEntity.ok(RestResponseDto.success(dto));
    }

    @PreAuthorize("isAuthenticated()")
    @PostMapping("/addReview")
    @ResponseBody
    public Review addReview(AddReviewForm form, @AuthenticationPrincipal LoginUser loginUser) {
        // 1. 등록할 리뷰 정보를 테이블에 저장한다.
        Review review = reviewService.addNewReview(form, loginUser.getNo());

        // 2. 등록한 리뷰 정보를 반환한다.
        return review;
    }

    @PreAuthorize("isAuthenticated()")
    @GetMapping("/deleteReview/{no}")
    public ResponseEntity<RestResponseDto<String>> deleteReview(@PathVariable("no") int reviewNo,
                                                                @AuthenticationPrincipal LoginUser loginUser) {
        // 1. 로그인한 사용자와 리뷰 작성자가 동일하면 리뷰를 삭제한다.
        try {
            reviewService.deleteReview(reviewNo, loginUser.getNo());
        } catch (CourseReviewException ex) {
            return ResponseEntity.ok(RestResponseDto.fail(ex.getMessage()));
        }

        // 2. 응답 데이터를 반환한다.
        return ResponseEntity.ok(RestResponseDto.success("review deleted"));
    }
}
