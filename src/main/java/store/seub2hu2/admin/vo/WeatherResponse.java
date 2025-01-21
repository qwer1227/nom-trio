package store.seub2hu2.admin.vo;

import com.fasterxml.jackson.annotation.JsonIgnoreProperties;
import lombok.Data;

import java.util.List;
@Data
public class WeatherResponse {

    private Main main;
    private List<Weather> weather;
    private String name; // 도시 이름

    @Data
    public static class Main {
        private double temp;
        private int humidity;
    }

    @Data
    public static class Weather {
        private String description;
    }
}
