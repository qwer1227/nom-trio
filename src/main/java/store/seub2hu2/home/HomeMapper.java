package store.seub2hu2.home;

import org.apache.ibatis.annotations.Mapper;
import store.seub2hu2.community.vo.Board;
import store.seub2hu2.community.vo.Marathon;
import store.seub2hu2.course.vo.Course;
import store.seub2hu2.lesson.vo.Lesson;
import store.seub2hu2.product.dto.ProdListDto;

import java.util.List;
import java.util.Map;

@Mapper
public interface HomeMapper {

    // 주간 베스트 상품 - 별점 순으로 조회
   List<ProdListDto> getWeeklyBestProductsByRating();

    // 주간 베스트 상품 - 조회수 순으로 조회 (러닝화 기준)
   List<ProdListDto> getWeeklyBestProductsByViewCount();

    // 최신 글 5개 조회
    List<Board> getTopViewedBoards();

    List<Board> getUserRankingByBoards();

    List<Marathon> getLatestMarathons();

    List<Lesson> getOngoingLessons();

    List<Course> getTopLikedCourses();
}
