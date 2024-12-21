package store.seub2hu2.mypage.service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;
import store.seub2hu2.mypage.dto.CommentRequest;
import store.seub2hu2.mypage.dto.CommentResponse;
import store.seub2hu2.mypage.mapper.PostMapper;
import store.seub2hu2.mypage.vo.Post;
import store.seub2hu2.mypage.vo.PostComment;
import store.seub2hu2.user.service.UserService;


import java.io.IOException;
import java.util.*;


@Service
public class PostService {

    @Autowired
    PostMapper postMapper;
    @Autowired
    UserService userService;


    public Post getPostDetail(int postNo){
        Post post = postMapper.getPostByNo(postNo);
        
        return post;
    }

    public int insertPost(Post post, int userNo){
        // 게시물을 먼저 INSERT 하여 POST_NO를 생성
        postMapper.insertPost(userNo, post);
        // 생성된 post_no 를 반환
        return post.getNo();
    }

    public List<Post> getPostsByNo(int userNo) {

        List<Post> posts = postMapper.getPostsByNo(userNo);

        return posts;
    }

    public boolean updatePost(int postId, String content, String thumbnailImage, MultipartFile[] files) {
        // 1. 게시글을 DB에서 찾기
        Post post = postMapper.getPostByNo(postId);

        if (post == null) {
            return false;
        }

        // 2. 게시글 내용 수정
        post.setPostContent(content);

        // 3. 섬네일 이미지 수정
        if (thumbnailImage != null) {
            post.setThumbnail(thumbnailImage);
        }

        // 4. 기존 이미지를 삭제하고 새 이미지 처리 (선택 사항)
        if (files != null && files.length > 0) {
            // 기존 이미지 삭제
            //postMapper.deletePostImagesByPostNo(postId);  // postId에 해당하는 기존 이미지 삭제

            // 새 이미지 파일 처리
            for (MultipartFile file : files) {
                saveImage(post, file);  // 이미지를 저장하는 메서드 호출
            }
        }

        // 5. 게시글 DB 업데이트
        postMapper.updatePost(post);

        return true;
    }

    private void saveImage(Post post, MultipartFile file) {
        // 파일을 base64로 변환
        String base64Image = convertFileToBase64(file);

        // 이미지를 저장하기 위해 `List`로 감싼 파라미터 생성
        List<Map<String, Object>> imageList = new ArrayList<>();
        Map<String, Object> param = new HashMap<>();
        param.put("imageUrl", base64Image);  // 이미지 데이터 (Base64)
        param.put("postNo", post.getNo());  // 게시글 번호
        imageList.add(param);  // `List`에 추가

        // Mapper를 통해 이미지 DB에 저장
        postMapper.insertPostImages(imageList);
    }


    public boolean deletePost(int postNo){
        postMapper.deletePost(postNo);

        return true;
    }

    public boolean imageDelete(int imageNo){
        postMapper.deletePostImagesByPostNo(imageNo);

        return true;
    }

    public boolean commentInsert(CommentRequest commentRequest, String username){

        PostComment postComment = new PostComment();
        // Post 번호 설정
        postComment.setCommentRequest(commentRequest);
        postComment.setUserName(username);


        if(commentRequest.getReplyToCommentNo() == null){
            commentRequest.setReplyToCommentNo(0);
        }


        postMapper.insertComment(postComment);

        return true;
    }

    public String getUserNameByUserNo(int userNo){
        String userName = postMapper.findByUserNo(userNo);

        return userName;
    }

    public List<CommentResponse> getCommentsByPostNo(int postNo){
        List<CommentResponse> comments = postMapper.getCommentsByPostNo(postNo);
        return comments;
    }

    // 파일을 base64로 변환하는 메소드 (MIME 타입 포함)
    private String convertFileToBase64(MultipartFile file) {
        try {
            // 파일의 MIME 타입을 추출
            String mimeType = file.getContentType();  // 예: image/png, image/jpeg 등
            byte[] fileBytes = file.getBytes();

            // "data:image/png;base64," 형태로 변환하여 반환
            return "data:" + mimeType + ";base64," + Base64.getEncoder().encodeToString(fileBytes);
        } catch (IOException e) {
            throw new RuntimeException("파일을 base64로 변환하는 중 오류가 발생했습니다.", e);
        }
    }



}
