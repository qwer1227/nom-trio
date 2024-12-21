package store.seub2hu2.course.exception;

public class CourseReviewException extends RuntimeException {
    public CourseReviewException(String message) {
        super(message);
    }

    public CourseReviewException(String message, Throwable cause) {
        super(message, cause);
    }
}
