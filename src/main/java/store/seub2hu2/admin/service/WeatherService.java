package store.seub2hu2.admin.service;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;
import org.springframework.web.client.RestTemplate;

@Service
public class WeatherService {
    private final RestTemplate restTemplate;

    // application.properties에서 API 키를 가져옵니다.
    @Value("${weather.api.key}")
    private String apiKey;

    private final String BASE_URL = "https://api.openweathermap.org/data/2.5/weather";

    public WeatherService(RestTemplate restTemplate) {
        this.restTemplate = restTemplate;
    }

    public String getWeatherByCity(String cityName) {
        String url = String.format("%s?q=%s&appid=%s&units=metric", BASE_URL, cityName, apiKey);
        return restTemplate.getForObject(url, String.class);
    }
}
