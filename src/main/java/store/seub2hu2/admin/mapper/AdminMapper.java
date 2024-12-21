package store.seub2hu2.admin.mapper;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;
import store.seub2hu2.admin.dto.*;
import store.seub2hu2.course.vo.Course;
import store.seub2hu2.course.vo.Region;
import store.seub2hu2.lesson.vo.Lesson;
import store.seub2hu2.lesson.vo.LessonReservation;
import store.seub2hu2.product.dto.ProdListDto;
import store.seub2hu2.product.vo.*;
import store.seub2hu2.user.vo.User;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Mapper
public interface AdminMapper {

    /*
     * 회원
     */
    int getTotalRows(@Param("condition") Map<String, Object> condition);
    List<User> getUsers(@Param("condition") Map<String, Object> condition);
    User getUserByNo(@Param("no") int no);

    /*
     * 코스 등록
     */
    void insertCourse(@Param("course") Course course);

    void insertRegion(@Param("region")Region region);

    Region getRegions(@Param("region")Region region);

    Region checkRegion(@Param("region")Region region);

    /*
     * 상품
     */
    // 상품 번호로 상품정보 전체 조회
    Product getProductByNo(int no);

    // 상품 번호와 색상에 해당하는 colorNo 값 조회
    Integer getColorNo(HashMap<String, Object> condition);

    // 색상이 없는 상품만 등록
    void insertProduct(@Param("condition") HashMap<String, Object> condition);

    // 색상 등록
    void insertColor(@Param("condition") HashMap<String, Object> condition);
    
    List<Lesson> getAllLessons(@Param("condition") Map<String, Object> condition);
    

    Category getTopCategoryNo(@Param("categoryNo") int categoryNo);

    void updateProduct(Product product);

    List<Color> colorNames(int no);

    void insertImage(Image img);

    List<Image> getImageByColorNum(Integer colorNo);

    Color getColorNoByNo(Integer colorNo);

    void getIsThumByNo(Integer imgNo);

    void getNullImageThum(Integer imgNo);

    void editUrl(Image img);

    List<Size> getAllSizesByColorNo(Integer colorNo);

    Size getCheckSizeByCon(@Param("size") Size size);

    void getInsertSize(@Param("size") Size size);

    void getDeleteSize(int sizeNo);

    void getChangeIsDeleted(@Param("size") Size size);

    List<Color> getStockByColorNumber(@Param("condition") Map<String, Object> condition);

    void insertStock(@Param("condition") Map<String, Object> condition);

    List<LessonUsersDto> getLessonUserByNo(Integer lessonNo);

    int getSettleTotalRows(@Param("condition") Map<String, Object> condition);

    List<SettlementDto> getSettleLists(@Param("condition") Map<String, Object> condition);

    Course getCourseByNos(int courseNo);

    void updateCourse(@Param("course") Course course);

    int getTotalBreath(@Param("day")String day);

    int getTotalAction(@Param("day")String day);

    int getTotalExercise(@Param("day")String day);

    int getTotalPriceByDay(String yesterday);

    int getTotalOrderProd(@Param("condition") Map<String, Object> condition);

    List<OrderProductDto> getSettleProdList(@Param("condition") Map<String, Object> condition);

    List<prevOrderProdDto> orderProdPrev(int orderNo);

    int getTotalProdPriceByDay(String yesterday);

    int getTotalOrderProdAmount(String yesterday);

    int getTotalProdMan(@Param("day")String day);

    int getTotalProdWoman(@Param("day")String day);

    int getTotalProdRun(@Param("day")String day);

    List<ProdListDto> getStockProducts(@Param("condition") Map<String, Object> condition);

    int getDeliveryTotalRows(@Param("condition")Map<String, Object> condition);

    List<orderDeliveryDto> getOrderDeliveries(@Param("condition") Map<String, Object> condition);

    void getDeletedProds(@Param("condition") Map<String, Object> condition);

    void getUpdateShows(@Param("condition") Map<String, Object> condition);

    void getDeletedCourses(@Param("courseNo")int courseNo);

    void getUpdateDeliverySetReady(@Param("condition") Map<String, Object> condition);

    void getUpdateDeliverySetShipped(@Param("condition") Map<String, Object> condition);

    void getUpdateDeliverySetDelivered(@Param("condition") Map<String, Object> condition);

    int getReportTotalRows(@Param("condition") Map<String, Object> condition);

    List<ReportDto> getReports(@Param("condition") Map<String, Object> condition);

    void updateBoardStatus(@Param("condition") Map<String, Object> condition);

    void updateBoardReplyStatus(@Param("condition") Map<String, Object> condition);

    void updateCrewStatus(@Param("condition") Map<String, Object> condition);

    void updateCrewReplyStatus(@Param("condition") Map<String, Object> condition);

    void updateReportStatus(@Param("condition") Map<String, Object> condition);






    /*
     * 재고
     */

    /*
     * 레슨
     */
}
