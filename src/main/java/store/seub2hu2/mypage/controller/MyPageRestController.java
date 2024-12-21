package store.seub2hu2.mypage.controller;

import lombok.extern.java.Log;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.actuate.web.mappings.MappingsEndpoint;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;
import retrofit2.http.Path;
import store.seub2hu2.community.service.BoardService;
import store.seub2hu2.community.service.CrewService;
import store.seub2hu2.community.vo.CrewMember;
import store.seub2hu2.mypage.dto.CommentRequest;
import store.seub2hu2.mypage.dto.ImageDeleteRequest;
import store.seub2hu2.mypage.dto.WorkoutDTO;
import store.seub2hu2.mypage.service.FileUploadService;
import store.seub2hu2.mypage.service.PostService;
import store.seub2hu2.mypage.service.WorkoutService;
import store.seub2hu2.mypage.vo.Post;
import store.seub2hu2.security.user.LoginUser;
import store.seub2hu2.user.service.UserService;
import store.seub2hu2.user.vo.UserImage;

import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;


@RestController
@RequestMapping("/mypage")
public class MyPageRestController {

    @Autowired
    private PostService postService;

    @Autowired
    private BoardService boardService;

    @Autowired
    private FileUploadService fileUploadService;

    @Autowired
    private CrewService crewService;


    @Autowired
    private UserService userService;
    @Autowired
    private WorkoutService workoutService;
    private MappingsEndpoint mappingsEndpoint;

    @PostMapping("/public/insert")
    public ResponseEntity<Map<String, Object>> insertPost(@RequestParam("content") String postContent,
                                                          @RequestParam("thumbnailImage") String thumb,
                                                          @RequestParam("files") List<MultipartFile> files,
                                                          @AuthenticationPrincipal LoginUser loginUser) {
        try {
            // 1. 게시글 생성
            Post post = new Post();
            post.setPostContent(postContent);
            post.setThumbnail(thumb);
            int postNo = postService.insertPost(post, loginUser.getNo());  // 게시글 생성 후 postNo 반환

            // 2. 파일 업로드 및 이미지 연결
            fileUploadService.saveFile(files, postNo, thumb);  // postNo와 함께 이미지 업로드

            // 3. 응답 반환
            Map<String, Object> response = new HashMap<>();
            response.put("message", "포스트 생성 완료");
            response.put("PostNo", postNo);
            response.put("thumb", thumb);
            return ResponseEntity.ok(response);

        } catch (Exception e) {
            e.printStackTrace();
            return ResponseEntity.status(500).body(Map.of("message", "포스트 생성 실패: " + e.getMessage()));
        }
    }

    @GetMapping("/detail/{no}")
    public Post getPostdetail(@PathVariable("no") int no) {
        return postService.getPostDetail(no);
    }


    @PutMapping("/detail/delete/{no}")
    public ResponseEntity<Map<String, Object>> deletePost(@PathVariable("no") int no) {

        Map<String, Object> response = new HashMap<>();

        try {
            //논리적 삭제 서비스
            boolean isDeleted = postService.deletePost(no);

            if (isDeleted) {
                response.put("message", "게시글이 성공적으로 삭제 처리되었습니다.");
                return ResponseEntity.ok(response);
            } else {
                response.put("message", "게시글을 찾을 수 없습니다.");
                return ResponseEntity.status(404).body(response);
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.put("message", "서버 오류");
            return ResponseEntity.status(500).body(response);
        }
    }

    @PutMapping("/detail/update/{no}")
    public ResponseEntity<Map<String, Object>> updatePost(@PathVariable("no") int no, //Path로 게시글 ID받기
                                                          @RequestParam("content") String content, // 수정할 게시글 내용
                                                          @RequestParam(name = "thumbnailImage", required = false) String thumbnailImage, // 수정할 썸네일 이미지
                                                          @RequestParam(name = "files", required = false) MultipartFile[] files
    ) {
        Map<String, Object> response = new HashMap<>();

        try {
            // 수정할 게시글을 서비스로 전달
            boolean isUpdated = postService.updatePost(no, content, thumbnailImage, files);

            if (isUpdated) {
                response.put("message", "게시글 수정 성공");
                return ResponseEntity.ok(response);
            } else {
                response.put("message", "게시글을 찾을 수 없습니다");
                return ResponseEntity.status(404).body(response);
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.put("message", "서버 오류");
            return ResponseEntity.status(500).body(response);
        }
    }

    @DeleteMapping("/detail/imagedelete/{no}")
    public ResponseEntity<Map<String, Object>> deleteImage(@PathVariable("no") int postNo,
                                                           @RequestBody ImageDeleteRequest request) {

        Map<String, Object> response = new HashMap<>();

        try {
            int imageNo = request.getImageNo();
            boolean isDeleted = postService.imageDelete(imageNo);

            if (isDeleted) {
                response.put("message", "삭제성공");
                return ResponseEntity.ok(response);
            } else {
                response.put("message", "게시글을 찾을 수 없습니다");
                return ResponseEntity.status(404).body(response);
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.put("message", "서버 오류");
            return ResponseEntity.status(500).body(response);
        }

    }


    @PostMapping("/detail/comment")
    public ResponseEntity<Map<String, Object>> addComment(@RequestBody CommentRequest request, @AuthenticationPrincipal LoginUser loginUser) {

        Map<String, Object> response = new HashMap<>();

        try {
            int postId = request.getPostId();
            String commentText = request.getPostComment();
            int userNo = loginUser.getNo();

            String userNickName = postService.getUserNameByUserNo(userNo); //22

            postService.commentInsert(request, userNickName);

            // todo 리스폰스DTO를 활용해서 수정/입력/삭제 될때 새로고침해서 클라이언트에게 보내주는 작업이 필요함
            response.put("message", "댓글성공");
            response.put("postId", postId);
            response.put("userNo", userNo);
            response.put("userNickName", userNickName);
            response.put("commentText", commentText);
            response.put("replyToUserNo", request.getReplyToUserNo());
            response.put("replyToCommentNo", request.getReplyToCommentNo());


            return ResponseEntity.ok(response);
        } catch (Exception e) {
            e.printStackTrace();
            response.put("message", "서버 오류");
            return ResponseEntity.status(500).body(response);
        }
    }

    @GetMapping("/getworkout")
    public List<Map<String,Object>> workout(@AuthenticationPrincipal  LoginUser loginUser){
        // 데이터베이스에서 일정 데이터를 조회

        List<WorkoutDTO> events = workoutService.getWorkoutByUserNo(loginUser.getNo());

        // FullCalendar 형식으로 변환
        return events.stream()
                .map(event ->{
                    Map<String, Object> map = new HashMap<>();
                    map.put("id", event.getWorkNo());
                    map.put("title", event.getTitle());
                    map.put("start", event.getStartDate());
                    map.put("content", event.getDescription());
                    map.put("userNo", event.getUserNo());
                    return map;
                })
                .collect(Collectors.toList());
    }

    @GetMapping("/getworkoutdetail/{no}")
    public ResponseEntity<Map<String, Object>> getWorkoutDetail(@PathVariable("no") int workoutNo){

        Map<String, Object> response = new HashMap<>();

        try{
            WorkoutDTO workoutDTO = workoutService.getWorkoutDetailByWorkoutNo(workoutNo);
            response.put("message", "성공");
            response.put("workoutDetail", workoutDTO);
        }catch (Exception e){
            e.printStackTrace();
            response.put("message", "서버 오류");
            return ResponseEntity.status(500).body(response);
        }
        return  ResponseEntity.ok(response);
    }

    @PostMapping("/postworkout")
    public ResponseEntity<Map<String,Object>> postWorkout(@RequestBody WorkoutDTO workoutDTO, @AuthenticationPrincipal LoginUser loginUser){

        Map<String, Object> response = new HashMap<>();

        try{
            workoutService.insertWorkout(workoutDTO, loginUser.getNo());
            response.put("message", "성공");
        } catch (Exception e){
            e.printStackTrace();
            response.put("message", "서버 오류");
            return ResponseEntity.status(500).body(response);
        }

        return ResponseEntity.ok(response);
    }

    @PutMapping("/putworkout/{no}")
    public ResponseEntity<Map<String, Object>> putWorkout(@PathVariable("no") int workoutNo, @RequestBody WorkoutDTO workoutDTO){

        Map<String, Object> response = new HashMap<>();

        try {
            workoutService.updateWorkout(workoutNo,workoutDTO);
        } catch (Exception e){
            e.printStackTrace();
            response.put("message", "서버 오류");
            return ResponseEntity.status(500).body(response);
        }
        return ResponseEntity.ok(response);
    }

    @PutMapping("/deleteworkout/{no}")
    public ResponseEntity<Map<String, Object>> deleteWorkout(@PathVariable("no") int workoutNo){

        Map<String, Object> response = new HashMap<>();

        try{
            workoutService.deleteWorkout(workoutNo);
        }catch (Exception e){
            e.printStackTrace();
            response.put("message", "서버 오류");
            return ResponseEntity.status(500).body(response);
        }
        return ResponseEntity.ok(response);
    }

    @GetMapping("/edit/nickname")
    public ResponseEntity<Map<String, Object>> editNickname(@RequestParam("nickname") String nickname){

        Map<String, Object> response = new HashMap<>();

        try{
            boolean isAvailable = userService.updateNickname(nickname);

            response.put("isAvailable", isAvailable);
        }catch (Exception e){
            e.printStackTrace();
            response.put("message", "서버 오류");
            return ResponseEntity.status(500).body(response);
        }
        return ResponseEntity.ok(response);
    }

    // 비밀번호와 같은 민감한 데이터는 단순 데이터비교만을 한다 한들 get요청보단 post요청을 하는게 낫다
    @PostMapping("/edit/password/check")
    public ResponseEntity<Map<String,Object>> checkPassword(@RequestBody Map<String,String> request, @AuthenticationPrincipal LoginUser loginUser){

        Map<String, Object> response = new HashMap<>();

        try{
            String newPassword = request.get("newPassword");

            // 기존 비밀번호와 비교
            boolean isSameAsOldPassword = userService.isSameAsOldPassword(newPassword, loginUser.getNo());

            response.put("isSameAsOldPassword", isSameAsOldPassword);
        }catch (Exception e){
            e.printStackTrace();
            response.put("message", "서버 오류");
            return ResponseEntity.status(500).body(response);
        }
        return ResponseEntity.ok(response);
    }

    @PostMapping("/userImageInsert/{no}")
    public ResponseEntity<Map<String, Object>> userImageInsert(@PathVariable("no") int userNo, @RequestParam("file") MultipartFile file){

        Map<String, Object> response = new HashMap<>();

        try{
            String filename = fileUploadService.userImageUpload(file, userNo);

            response.put("success", true);
            response.put("imageUrl", "https://2404-bucket-team-1.s3.ap-northeast-2.amazonaws.com/resources/images/userImage/"+filename);
        }catch (Exception e){
            e.printStackTrace();
            response.put("message", "서버 오류");
            return ResponseEntity.status(500).body(response);
        }
        return ResponseEntity.ok(response);
    }

    @GetMapping("/getCrewMembers/{crewNo}")
    public List<CrewMember> getCrewMembers(@PathVariable("crewNo") int crewNo) {
        // CrewService를 통해 크루 멤버 리스트 가져오기
        List<CrewMember> availableMembers = crewService.getCrewMembersByCrewId(crewNo);

        return availableMembers;
    }

    @PutMapping("/transferLeader")
    public ResponseEntity<Map<String, Object>> updateReader(@RequestBody Map<String, Integer> request, @AuthenticationPrincipal LoginUser loginUser){

        Map<String, Object> response = new HashMap<>();

        try{
            int userNo = request.get("userNo");
            int crewNo = request.get("crewNo");

            crewService.updateReader(userNo,crewNo, loginUser.getNo());

            response.put("success", true);

            return ResponseEntity.ok(response);
        } catch (Exception e){
            e.printStackTrace();
            response.put("message", "서버 오류");
            return ResponseEntity.status(500).body(response);
        }

    }

    @PutMapping("/leaveCrew")
    public ResponseEntity<Map<String, Object>> leaveCrew(@RequestBody Map<String, Integer> request, @AuthenticationPrincipal LoginUser loginUser){

        Map<String , Object> response = new HashMap<>();

        try{
            int crewNo = request.get("crewNo");
            crewService.leaveCrew(crewNo,loginUser);

            response.put("success", true);

            return ResponseEntity.ok(response);
        } catch (Exception e){
            e.printStackTrace();
            response.put("message", "서버 오류");
            return ResponseEntity.status(500).body(response);
        }
    }

}
