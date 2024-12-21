package store.seub2hu2.order.advice;

import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.ControllerAdvice;
import org.springframework.web.bind.annotation.ExceptionHandler;
import store.seub2hu2.order.exception.*;

@ControllerAdvice
public class OrderPaymentExceptionHandler {

    // 상품 재고 부족 에러
    @ExceptionHandler(OutOfStockException.class)
    public ResponseEntity<String> handleOutOfStockException (OutOfStockException ex) {
        return ResponseEntity.status(HttpStatus.CONFLICT).body(ex.getMessage());
    }

    // 결제 금액 불일치 예외 처리
    @ExceptionHandler(PaymentAmountMismatchException.class)
    public ResponseEntity<String> handlePaymentAmountMismatchException(PaymentAmountMismatchException ex) {
        return ResponseEntity.status(HttpStatus.BAD_REQUEST).body(ex.getMessage());
    }

    // DB 저장 실패 예외 처리
    @ExceptionHandler(DatabaseSaveException.class)
    public ResponseEntity<String> handleDatabaseSaveException(DatabaseSaveException ex) {
        return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body("DB 저장 오류: " + ex.getMessage());
    }

    // 상품 정보 오류 예외 처리
    @ExceptionHandler(ProductNotFoundException.class)
    public ResponseEntity<String> handleProductNotFoundException(ProductNotFoundException ex) {
        return ResponseEntity.status(HttpStatus.NOT_FOUND).body(ex.getMessage());
    }

    // 결제 시스템 오류 예외 처리
    @ExceptionHandler(PaymentSystemException.class)
    public ResponseEntity<String> handlePaymentSystemException(PaymentSystemException ex) {
        return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body("결제 시스템 오류: " + ex.getMessage());
    }
}
