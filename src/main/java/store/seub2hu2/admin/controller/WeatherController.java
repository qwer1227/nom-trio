package store.seub2hu2.admin.controller;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.client.RestTemplate;
import store.seub2hu2.admin.vo.WeatherResponse;

@RestController
public class WeatherController {

    private final RestTemplate restTemplate;
    @Value("${weather.api.key}") // application.properties에 정의된 값 가져오기
    private String apiKey;

    private final String BASE_URL = "https://api.openweathermap.org/data/2.5/weather";
    public WeatherController(RestTemplate restTemplate) {
        this.restTemplate = restTemplate;
    }

    @GetMapping("/weather")
    public String getWeather(@RequestParam(defaultValue = "Seoul") String city, Model model) {
        String url = String.format("%s?q=%s&appid=%s&units=metric", BASE_URL, city, apiKey);
        try {
            WeatherResponse weatherResponse = restTemplate.getForObject(url, WeatherResponse.class);
            model.addAttribute("city", city);
            model.addAttribute("temp", weatherResponse.getMain().getTemp());
            model.addAttribute("description", weatherResponse.getWeather().get(0).getDescription());
        } catch (Exception e) {
            model.addAttribute("error", "날씨 정보를 가져올 수 없습니다.");
        }
        return "weather"; // weather.jsp를 렌더링
    }
}
