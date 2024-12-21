package store.seub2hu2.course.service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import store.seub2hu2.course.mapper.CourseMapper;
import store.seub2hu2.course.vo.*;
import store.seub2hu2.util.ListDto;
import store.seub2hu2.util.Pagination;

import java.util.List;
import java.util.Map;

@Service
@Transactional
public class CourseService {
    @Autowired
    private CourseMapper courseMapper;

    /**
     * 전체 코스 목록을 가져온다.
     * @return 코스 목록
     */
    public List<Course> getCourses() {
        // 1. 전체 코스 목록을 가져온다.
        List<Course> courses = courseMapper.getAllCourses();

        // 2. 전체 코스 목록을 반환한다.
        return courses;
    }

    /**
     * 검색에 해당하는 코스 목록을 가져온다.
     * @param condition 검색 정보
     * @return 코스 목록
     */
    public ListDto<Course> getAllCourses(Map<String, Object> condition) {
        // 1. 전체 코스의 갯수를 조회한다.
        int totalRows = courseMapper.getTotalRows(condition);

        // 2. 페이징 처리 정보를 가져오고, Pagination 객체에 저장한다.
        int page = (Integer) condition.get("page");
        Pagination pagination = new Pagination(page, totalRows, 8);

        // 3. 데이터 검색 범위를 조회해서 Map에 저장한다.
        condition.put("begin", pagination.getBegin());
        condition.put("end", pagination.getEnd());

        // 4. 조회범위에 맞는 코스 목록을 조회한다.
        List<Course> courses = courseMapper.getCourses(condition);

        // 5. ListDto 객체에 화면에 표시할 데이터(코스 목록, 페이징 처리 정보)를 담고, 반환한다.
        ListDto<Course> dto = new ListDto<>(courses, pagination);
        return dto;
    }

    /**
     * 코스 번호로 코스 상세 정보를 가져온다.
     * @param courseNo 코스 번호
     * @return 코스 상세 정보
     */
    public Course getCourseDetail(int courseNo) {
        // 1. 코스 번호로 코스의 상세 정보를 가져온다.
        Course course = courseMapper.getCourseByNo(courseNo);

        // 2. 코스의 상세 정보를 반환한다.
        return course;
    }
}
