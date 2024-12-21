package store.seub2hu2.home;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import store.seub2hu2.community.vo.Board;
import store.seub2hu2.community.vo.Marathon;
import store.seub2hu2.course.vo.Course;
import store.seub2hu2.lesson.vo.Lesson;
import store.seub2hu2.product.dto.ProdListDto;

import java.util.List;
import java.util.Map;

@Service
public class HomeService {

    @Autowired
    private HomeMapper homeMapper;


    // 최신 게시글 5개 조회
    public List<Board> getTopViewedBoards() {
        return homeMapper.getTopViewedBoards(); // 최신 글 5개 반환
    }

    public List<Board> getUserRankingByBoards() {
        return homeMapper.getUserRankingByBoards();
    }


    // 접수 마감일순 마라톤 정보 5개 조회
    public List<Marathon> getLatestMarathons() {
        return homeMapper.getLatestMarathons();
    }

    // 최신 글 5개 조회
    public List<Lesson> getOngoingLessons() {
        return homeMapper.getOngoingLessons ();
    }

    // 주간 베스트 상품 - 별점 순으로 조회
    public List<ProdListDto> getWeeklyBestProductsByRating() {
        return homeMapper.getWeeklyBestProductsByRating();
    }

    // 주간 베스트 러닝화 - 조회수 순으로 조회 (러닝화 기준)
    public List<ProdListDto> getWeeklyBestProductsByViewCount() {
        List<ProdListDto> products = homeMapper.getWeeklyBestProductsByViewCount();

        // 순위 변동 계산
        for (int i = 0; i < products.size(); i++) {
            ProdListDto currentProduct = products.get(i);
            if (i > 0) {
                // 이전 상품과 비교하여 rankChange 계산
                ProdListDto previousProduct = products.get(i - 1);

                // 예시로, 순위가 변경된 이유를 조회수 또는 가격으로 설정 가능
                if (currentProduct.getCnt() < previousProduct.getCnt()) {
                    currentProduct.setRankChange(1); // 상승
                } else if (currentProduct.getCnt() > previousProduct.getCnt()) {
                    currentProduct.setRankChange(-1); // 하강
                } else {
                    currentProduct.setRankChange(0); // 변동 없음
                }
            } else {
                currentProduct.setRankChange(0); // 첫 번째 상품은 변동 없음
            }
        }

        return products;
    }

    public List<Course> getTopLikedCourses() {
        return homeMapper.getTopLikedCourses();
    }

}

