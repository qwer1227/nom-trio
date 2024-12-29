package store.seub2hu2.admin.controller;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.util.StringUtils;
import org.springframework.web.bind.annotation.*;
import store.seub2hu2.admin.dto.OrderProductDto;
import store.seub2hu2.admin.dto.SettlementDto;
import store.seub2hu2.admin.dto.orderDeliveryDto;
import store.seub2hu2.admin.dto.prevOrderProdDto;
import store.seub2hu2.admin.service.AdminService;
import store.seub2hu2.product.dto.ProdListDto;
import store.seub2hu2.product.vo.Color;
import store.seub2hu2.product.vo.Product;
import store.seub2hu2.product.vo.Size;
import store.seub2hu2.util.ListDto;

import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Controller
@RequestMapping("/admin/settlement")
@RequiredArgsConstructor
@Slf4j
public class AdminSettlementController {

    private final AdminService adminService;

    @GetMapping("/product-stock-detail")
    public String getProductStockDetail(@RequestParam("no") int no,
                                        @RequestParam("colorNo") Integer colorNo,
                                        @RequestParam(name = "colorName", required = false) String colorName,
                                        Model model) {

        Product product = adminService.getProductNo(no);
        List<Color> colors = adminService.getColorName(no);
        List<Size> sizes = adminService.getAllSizeByColorNo(colorNo);

        Map<String, Object> condition = new HashMap<>();
        condition.put("no", no);
        condition.put("colorName", colorName);

        List<Color> colorSize = adminService.getStockByColorNum(condition);


        if (colorSize == null || colorSize.isEmpty()) {
            model.addAttribute("colorSize", null);
            model.addAttribute("sizeMessage", "사이즈 정보가 없습니다.");

        } else {
            model.addAttribute("colorSize", colorSize);
            model.addAttribute("sizeMessage", null);


        }

        model.addAttribute("colorSize", colorSize);
        model.addAttribute("sizes", sizes);
        model.addAttribute("product", product);
        model.addAttribute("colors", colors);

        return "admin/settlement/product-stock-detail";
    }

    @PostMapping("/product-stock-detail")
    public String productStockDetail(@RequestParam("no") int no,
                                     @RequestParam(name = "colorNo") Integer colorNo,
                                     @RequestParam(name = "colorName", required = false) String colorName,
                                     @RequestParam("size") List<String> size,
                                     @RequestParam("amount") List<Integer> amount,
                                     Model model) {

        Map<String, Object> condition = new HashMap<>();
        condition.put("no", no);
        condition.put("colorName", colorName);

        for (int i = 0; i < size.size(); i++) {
            String currentSize = size.get(i);
            Integer currentAmount = amount.get(i);

            condition.put("size", currentSize);
            condition.put("amount", currentAmount);


            adminService.getInsertStock(condition);
        }

        return "redirect:/admin/product/detail?no=" + no + "&colorNo=" + colorNo;
    }

    @GetMapping("/product-stock")
    public String getProductStock(@RequestParam(name = "topNo") int topNo,
                                  @RequestParam(name = "catNo", required = false, defaultValue = "0") int catNo,
                                  @RequestParam(name = "page", required = false, defaultValue = "1") int page,
                                  @RequestParam(name = "rows", required = false, defaultValue = "10") int rows,
                                  @RequestParam(name = "sort", required = false, defaultValue = "date") String sort,
                                  @RequestParam(name = "opt", required = false) String opt,
                                  @RequestParam(name = "value", required = false) String value,

                                  Model model) {

        Map<String, Object> condition = new HashMap<>();
        condition.put("topNo", topNo);
        if (catNo != 0) {
            condition.put("catNo", catNo);
        }

        condition.put("page", page);
        condition.put("rows", rows);
        condition.put("sort", sort);
        if(StringUtils.hasText(opt)) {
            condition.put("opt", opt);
            condition.put("value", value);
        }

        ListDto<ProdListDto> dto = adminService.getStockProduct(condition);
        model.addAttribute("topNo", topNo);
        model.addAttribute("catNo", catNo);
        model.addAttribute("products", dto.getData());
        model.addAttribute("paging", dto.getPaging());

        return "admin/settlement/product-stock";
    }

    @PostMapping("/product-stock")
    public String productStock(@RequestParam("Y") String Y,
                               @RequestParam("no") int no,
                               @RequestParam("topNo") int topNo){

        Map<String, Object> condition = new HashMap<>();
        condition.put("Y", Y);
        condition.put("no", no);

        adminService.getDeletedProd(condition);

        return  "redirect:/admin/settlement/product-stock?topNo=" + topNo;
    }

    @PostMapping("/product-show")
    public String productShow(@RequestParam("no") int no,
                              @RequestParam("topNo") int topNo,
                              @RequestParam("show") String show) {


        Map<String, Object> condition = new HashMap<>();
        condition.put("no", no);
        condition.put("show", show);

        // 노출 상태 변경 처리
        adminService.updateProductShowStatus(condition);

        return "redirect:/admin/settlement/product-stock?topNo=" + topNo;
    }


    @PostMapping("/updateDeliveryStatus")
    public String updateDeliveryStatus(@RequestParam(name="page", required = false,defaultValue ="1") int page,
                                       @RequestParam(name="rows", required = false,defaultValue ="10") int rows,
                                       @RequestParam(name="day", required = false) String day,
                                       @RequestParam("deliNo") int deliNo,
                                       @RequestParam("deliStatus") String deliStatus) {

        Map<String, Object> condition = new HashMap<>();
        condition.put("deliNo", deliNo);
        condition.put("deliStatus", deliStatus);

        System.out.println("----------------condition" + condition);

        adminService.getUpdateDelivery(condition);


        return "redirect:/admin/order-delivery?page=" + page + "&rows" + rows + "&day=" + day;
    }

    @GetMapping("/order-delivery")
    public String order(@RequestParam(name = "page", required = false, defaultValue = "1") int page,
                        @RequestParam(name = "rows", required = false, defaultValue = "10") int rows,
                        @RequestParam(name = "day", required = false) String day,
                        @RequestParam(name = "sort", required = false, defaultValue = "latest") String sort,
                        @RequestParam(name = "opt", required = false) String opt,
                        @RequestParam(name = "keyword", required = false) String keyword,
                        @RequestParam(name = "value", required = false) String value,
                        Model model){

        if (day == null || day.isEmpty()) {
            // 현재 날짜로 기본 설정
            SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
            day = sdf.format(new Date());
        }

        Map<String, Object> condition = new HashMap<>();
        condition.put("page", page);
        condition.put("rows", rows);
        condition.put("day", day);
        condition.put("sort", sort);

        if(StringUtils.hasText(opt)) {
            condition.put("opt", opt);
            condition.put("keyword", keyword);
            condition.put("value", value);
        }


        ListDto<orderDeliveryDto> dto = adminService.getOrderDelivery(condition);

        model.addAttribute("dto", dto.getData());
        model.addAttribute("paging", dto.getPaging());

        return "admin/settlement/order-delivery";
    }



    @GetMapping("/chart")
    public Map<String, Object> chart(@RequestParam(name = "day", required = false) String day,

                                     Model model) {

        if (day == null || day.isEmpty()) {
            // 현재 날짜로 기본 설정
            SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
            day = sdf.format(new Date());
        }

        Map<String, Object> conditions = adminService.getTotalSubject(day);

        model.addAttribute("conditions", conditions);

        return conditions;
    }

    @GetMapping("/p-settlement/preview")
    @ResponseBody
    public List<prevOrderProdDto> prodPreview(@RequestParam("orderNo") int orderNo
    ) {

        List<prevOrderProdDto> dtos = adminService.getOrderProdPrev(orderNo);


        return dtos;
    }

    @GetMapping("/p-settlement")
    public String pSettlement(@RequestParam(name = "page", required = false, defaultValue = "1") int page,
                              @RequestParam(name = "rows", required = false, defaultValue = "10") int rows,
                              @RequestParam(name = "sort", required = false) String sort,
                              @RequestParam(name = "opt", required = false, defaultValue = "all") String opt,
                              @RequestParam(name = "day", required = false) String day,
                              @RequestParam(name = "keyword", required = false, defaultValue = "all") String keyword,
                              @RequestParam(name = "value", required = false) String value,
                              Model model) {

        if (day == null || day.isEmpty()) {
            // 현재 날짜로 기본 설정
            SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
            day = sdf.format(new Date());
        }

        Map<String, Object> condition = new HashMap<>();
        condition.put("page", page);
        condition.put("rows", rows);
        condition.put("sort", sort);
        condition.put("opt", opt);

        if (StringUtils.hasText(day)) {
            condition.put("day", day);
        }

        if (StringUtils.hasText(value)) {
            condition.put("keyword", keyword);
            condition.put("value", value);
        }

        ListDto<OrderProductDto> dto = adminService.getOrderProduct(condition);

        int totalPriceSum = dto.getData().stream()
                .mapToInt(OrderProductDto::getTotalPrice)
                .distinct()   // 중복된 값 제거 (한 번만 합산)
                .limit(1)     // 첫 번째 값만 선택
                .sum();

        model.addAttribute("totalPriceSum", totalPriceSum);

        model.addAttribute("dto", dto.getData());
        model.addAttribute("paging", dto.getPaging());

        return "admin/settlement/p-settlement";
    }

    @GetMapping("/l-settlement")
    public String settlement(@RequestParam(name = "page", required = false, defaultValue = "1") int page,
                             @RequestParam(name = "rows", required = false, defaultValue = "10") int rows,
                             @RequestParam(name = "pType", required = false, defaultValue = "lesson") String pType,
                             @RequestParam(name = "day", required = false) String day,
                             @RequestParam(name = "sort", required = false, defaultValue ="latest") String sort,
                             @RequestParam(name = "opt", required = false, defaultValue = "all") String opt,
                             @RequestParam(name = "keyword", required = false) String keyword,
                             @RequestParam(name = "value", required = false) String value,
                             Model model) {

        if (day == null || day.isEmpty()) {
            // 현재 날짜로 기본 설정
            SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
            day = sdf.format(new Date());
        }


        Map<String, Object> condition = new HashMap<>();
        condition.put("page", page);
        condition.put("rows", rows);
        condition.put("pType", pType);

        condition.put("sort", sort);
        condition.put("opt", opt);

        if (StringUtils.hasText(day)) {
            condition.put("day", day);
        }

        if (StringUtils.hasText(value)) {
            condition.put("keyword", keyword);
            condition.put("value", value);
        }

        ListDto<SettlementDto> dto = adminService.getSettleList(condition);

        int totalPriceSum = dto.getData().stream()
                .mapToInt(SettlementDto::getTotalPrice)
                .distinct()   // 중복된 값 제거 (한 번만 합산)
                .limit(1)     // 첫 번째 값만 선택
                .sum();

        model.addAttribute("totalPriceSum", totalPriceSum);
        model.addAttribute("dto", dto.getData());
        model.addAttribute("paging", dto.getPaging());

        return "admin/settlement/l-settlement";
    }
}
