package store.seub2hu2.admin.vo;

import lombok.Data;

import java.util.List;

@Data
public class ForecastResponse {
    private List<Forecast> list;

    @Data
    public static class Forecast {
        private Main main;
        private List<Weather> weather;
        private String dt_txt; // 예보 시간

        @Data
        public static class Main {
            private double temp;
        }

        @Data
        public static class Weather {
            private String description;
        }
    }
}
