package store.seub2hu2.admin.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;
import store.seub2hu2.admin.service.AdminService;

import java.text.SimpleDateFormat;
import java.util.Arrays;
import java.util.Date;
import java.util.HashMap;
import java.util.Map;

@RestController
@RequestMapping("/admin")
public class AdminRestController {

    @Autowired
    private AdminService adminService;

    @GetMapping("/getHome")
    public ResponseEntity<Map<String, Object>> getHome(@RequestParam(name = "day", required = false) String day

                                                       ) {
        if (day == null || day.isEmpty()) {
            // 현재 날짜로 기본 설정
            SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
            day = sdf.format(new Date());
        }

        // 금일 날짜 계산
        String today = day;

        // 하루 전 날짜 계산
        SimpleDateFormat formatter = new SimpleDateFormat("yyyy-MM-dd");
        Date currentDate = new Date();
        currentDate.setTime(currentDate.getTime() - (1000 * 60 * 60 * 24));  // 하루 전
        String yesterday = formatter.format(currentDate);

        // 금일 데이터 조회
        Map<String, Object> conditions = adminService.getTotalSubject(today);
        // 하루 전날 데이터 조회
        Map<String, Object> yesterdayData = adminService.getTotalPrice(yesterday);
        // 하루 전날 상품매출 조회
        Map<String, Object> yesterdayProdData = adminService.getTotalProdPrice(yesterday);

        Map<String, Object> yesterdayProdAmount = adminService.getTotalProdAmount(yesterday);

        conditions.put("day", day);
        conditions.put("yesterdayTotalProdAmount",yesterdayProdAmount.get("totalProdAmount"));
        conditions.put("yesterdayProdPrice", yesterdayProdData.get("totalProdPrice"));
        conditions.put("yesterdayPrice", yesterdayData.get("totalPrice"));
        conditions.put("labels", Arrays.asList("호흡", "자세", "운동"));
        conditions.put("data", Arrays.asList(conditions.get("breath"), conditions.get("action"), conditions.get("exercise")));

        return ResponseEntity.ok(conditions);
    }

    @GetMapping("/getChart")
    public ResponseEntity<Map<String, Object>> chart(@RequestParam(name = "day", required = false) String day) {

        if (day == null || day.isEmpty()) {
            // 현재 날짜로 기본 설정
            SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
            day = sdf.format(new Date());
        }

        Map<String, Object> conditions = adminService.getTotalSubject(day);

        conditions.put("day", day);
        conditions.put("labels", Arrays.asList("호흡", "자세", "운동"));
        conditions.put("data", Arrays.asList(conditions.get("breath"), conditions.get("action"), conditions.get("exercise")));

        Map<String, Object> conditions2 = adminService.getTotalProdCatNo(day);
        conditions.putAll(conditions2);

        conditions.put("labels2", Arrays.asList("남성상품", "여성상품", "러닝용품"));
        conditions.put("data2", Arrays.asList(conditions2.get("man"), conditions2.get("woman"), conditions2.get("run")));


        return ResponseEntity.ok(conditions);
    }
}
