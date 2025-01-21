package store.seub2hu2.admin.controller;

import com.fasterxml.jackson.core.type.TypeReference;
import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.format.annotation.DateTimeFormat;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.util.StringUtils;
import org.springframework.validation.BindingResult;
import org.springframework.validation.annotation.Validated;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.client.RestTemplate;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;
import store.seub2hu2.admin.dto.*;
import store.seub2hu2.admin.service.AdminService;
import store.seub2hu2.admin.vo.ForecastResponse;
import store.seub2hu2.admin.vo.WeatherResponse;
import store.seub2hu2.community.service.MarathonService;
import store.seub2hu2.community.service.NoticeService;
import store.seub2hu2.community.vo.Marathon;
import store.seub2hu2.community.vo.Notice;
import store.seub2hu2.course.service.CourseService;
import store.seub2hu2.course.service.UserCourseService;
import store.seub2hu2.course.vo.Course;
import store.seub2hu2.lesson.dto.LessonRegisterForm;
import store.seub2hu2.lesson.dto.LessonUpdateForm;
import store.seub2hu2.lesson.service.LessonFileService;
import store.seub2hu2.lesson.service.LessonService;
import store.seub2hu2.lesson.vo.Lesson;
import store.seub2hu2.mypage.dto.AnswerDTO;
import store.seub2hu2.mypage.dto.QnaResponse;
import store.seub2hu2.mypage.service.QnaService;
import store.seub2hu2.product.dto.*;
import store.seub2hu2.product.service.ProductService;
import store.seub2hu2.product.vo.*;
import store.seub2hu2.product.vo.Category;
import store.seub2hu2.product.vo.Color;
import store.seub2hu2.product.vo.Image;
import store.seub2hu2.product.vo.Product;
import store.seub2hu2.security.user.LoginUser;
import store.seub2hu2.user.service.UserService;
import store.seub2hu2.user.vo.User;
import store.seub2hu2.util.ListDto;

import java.io.IOException;
import java.text.SimpleDateFormat;
import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.util.*;


@Controller
@RequestMapping("/admin")
@Slf4j
public class AdminController {

    private final RestTemplate restTemplate;

    @Value("${weather.api.key}") // application.properties에서 API 키를 가져옴
    private String apiKey;

    private final String CURRENT_WEATHER_URL = "https://api.openweathermap.org/data/2.5/weather";
    private final String FORECAST_URL = "https://api.openweathermap.org/data/2.5/forecast";

    public AdminController(RestTemplate restTemplate) {
        this.restTemplate = restTemplate;
    }

    @GetMapping("/home")
    public String home(@RequestParam(name = "city", defaultValue = "Seoul") String city, Model model) {
        // 현재 날씨 URL
        String currentWeatherUrl = String.format("%s?q=%s&appid=%s&units=metric", CURRENT_WEATHER_URL, city, apiKey);
        // 5일/3시간 예보 URL
        String forecastUrl = String.format("%s?q=%s&appid=%s&units=metric", FORECAST_URL, city, apiKey);

        try {
            // 현재 날씨 정보 요청
            WeatherResponse currentWeather = restTemplate.getForObject(currentWeatherUrl, WeatherResponse.class);
            model.addAttribute("currentWeather", currentWeather);

            // 5일/3시간 예보 정보 요청
            ForecastResponse forecastResponse = restTemplate.getForObject(forecastUrl, ForecastResponse.class);
            model.addAttribute("forecastList", forecastResponse.getList());
        } catch (Exception e) {
            log.error("날씨 정보를 가져오는 중 오류 발생: ", e);
            model.addAttribute("error", "날씨 정보를 가져올 수 없습니다.");
        }

        return "admin/home"; // admin/home.jsp가 topbar.jsp를 포함
    }

}
