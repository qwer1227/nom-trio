package store.seub2hu2.admin.controller;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.util.StringUtils;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;
import store.seub2hu2.admin.dto.ColorThumbnailForm;
import store.seub2hu2.admin.dto.ProductRegisterForm;
import store.seub2hu2.admin.service.AdminService;
import store.seub2hu2.product.dto.*;
import store.seub2hu2.product.service.ProductService;
import store.seub2hu2.product.vo.*;
import store.seub2hu2.util.ListDto;

import java.util.Collections;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Controller
@RequestMapping("/admin/product")
@RequiredArgsConstructor
@Slf4j
public class AdminProductController {

    private final ProductService productService;
    private final AdminService adminService;

    @GetMapping("/list")
    public String list(@RequestParam(name= "topNo") int topNo,
                       @RequestParam(name = "catNo", required = false, defaultValue = "0") int catNo,
                       @RequestParam(name = "page", required = false, defaultValue = "1") int page,
                       @RequestParam(name = "rows", required = false, defaultValue = "6") int rows,
                       @RequestParam(name = "sort" , required = false, defaultValue = "date") String sort,
                       @RequestParam(name = "opt", required = false) String opt,
                       @RequestParam(name = "value", required = false) String value,
                       Model model) {

        Map<String, Object> condition = new HashMap<>();
        condition.put("topNo", topNo);
        if(catNo != 0) {
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

        return "admin/product/list";
    }

    @GetMapping("/edit")
    public String registerEditForm(@RequestParam("no") int no,
                                   @RequestParam(value = "colorNo", required = false) Integer colorNo,
                                   Model model) {

        Product product = adminService.getProductNo(no);

        List<Color> colors = adminService.getColorName(no);

        model.addAttribute("colors", colors);
        model.addAttribute("product", product);


        return "admin/product/edit-form";
    }

    @PostMapping("/edit")
    public String registerEditTitle(Product product,
                                    RedirectAttributes redirectAttributes) {
        try {
            adminService.getUpdateProduct(product); // 수정 처리
            redirectAttributes.addFlashAttribute("successMessage", "수정이 완료되었습니다.");
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("errorMessage", "수정 중 오류가 발생했습니다.");
        }

        return "redirect:/admin/product/register-form?no=" + product.getNo() + "&colorNo=" + product.getColorNum();
    }

    @GetMapping("/size-delete")
    public String getDeleteSize(@RequestParam("no") int no,
                                @RequestParam("colorNo") Integer colorNo,
                                Model model) {

        // 상품 정보 가져오기
        Product product = adminService.getProductNo(no);
        List<Color> colors = adminService.getColorName(no);
        Color color = adminService.getColorNo(colorNo);
        List<Size> sizes = adminService.getAllSizeByColorNo(colorNo);

        model.addAttribute("product", product);
        model.addAttribute("colors", colors);
        model.addAttribute("color", color);
        model.addAttribute("sizes", sizes);

        if (sizes == null || sizes.isEmpty()) {
            model.addAttribute("sizeMessage", "등록된 사이즈가 없습니다.");
            sizes = Collections.emptyList(); // 비어 있는 리스트 전달
        }

        return "admin/product/size-delete-form";
    }

    @PostMapping("/delete-size")
    public String deleteSize(@RequestParam("no") int no,
                             @RequestParam("colorNo") Integer colorNo,
                             @RequestParam("sizeNo") int sizeNo,
                             Model model) {

        adminService.getDeletedSize(sizeNo);

        return "redirect:/admin/product/delete-size?no=" + no + "&colorNo=" + colorNo;
    }

    @GetMapping("/size-register")
    public String registerSize(@RequestParam("no") int no,
                               @RequestParam("colorNo") Integer colorNo,
                               Model model) {

        // 상품 정보 가져오기
        Product product = adminService.getProductNo(no);
        List<Color> colors = adminService.getColorName(no);
        Color color = adminService.getColorNo(colorNo);
        List<Size> sizes = adminService.getAllSizeByColorNo(colorNo);

        if (sizes == null || sizes.isEmpty()) {
            model.addAttribute("sizeMessage", "등록된 사이즈가 없습니다.");
            sizes = Collections.emptyList(); // 비어 있는 리스트 전달
        }
        // 모델에 데이터 추가
        model.addAttribute("product", product);
        model.addAttribute("colors", colors);
        model.addAttribute("color", color);
        model.addAttribute("sizes", sizes);

        return "admin/product/size-register-form";
    }

    @PostMapping("/size-register")
    public String registerSize(@RequestParam("no") int no,
                               @RequestParam("colorNo") Integer colorNo,
                               @RequestParam("size") String size,
                               RedirectAttributes redirectAttributes) {

        Map<String, Object> condition = new HashMap<>();
        condition.put("colorNo", colorNo);
        condition.put("size", size);

        try {

            adminService.getCheckSize(condition);
        } catch (IllegalArgumentException e) {

            redirectAttributes.addFlashAttribute("errorMessage", e.getMessage());
        }


        return "redirect:/admin/product/size-register?no=" + no + "&colorNo=" + colorNo;


    }


    @GetMapping("/image-edit")
    public String getImageEditForm(@RequestParam("no") int no,
                                   @RequestParam("colorNo") Integer colorNo,
                                   Model model) {

        Product product = adminService.getProductNo(no);

        Color color = adminService.getColorNo(colorNo);

        List<Color> colors = adminService.getColorName(no);
        List<Image> images = adminService.getImageByColorNo(colorNo);

        model.addAttribute("product", product);
        model.addAttribute("color", color);
        model.addAttribute("colors", colors);
        model.addAttribute("images", images);

        return "admin/product/image-edit-form";
    }

    @PostMapping("/image-edit")
    public String imageEditForm(@RequestParam("no") int no,
                                @RequestParam("colorNo") Integer colorNo,
                                @RequestParam("imgNo") List<Integer> imgNoList,
                                @RequestParam("url") List<String> urlList) {

        List<Image> images = adminService.getImageByColorNo(colorNo);

        adminService.getEditUrl(imgNoList, urlList);

        return "redirect:/admin/product/detail?no=" + no + "&colorNo=" + colorNo;
    }

    @GetMapping("/image-title")
    public String getImageChangeForm(@RequestParam("no") int no,
                                     @RequestParam("colorNo") Integer colorNo,
                                     Model model) {

        Product product = adminService.getProductNo(no);

        List<Color> colors = adminService.getColorName(no);

        Color color = adminService.getColorNo(colorNo);

        List<Image> images = adminService.getImageByColorNo(colorNo);
        model.addAttribute("images", images);

        if (images.isEmpty()) {
            model.addAttribute("noImages", true); // 이미지가 없다는 플래그 추가
        } else {
            model.addAttribute("images", images);
        }

        model.addAttribute("color", color);
        model.addAttribute("colors", colors);
        model.addAttribute("product", product);

        return "admin/product/image-title-form";
    }

    @PostMapping("/image-title")
    public String imageChangeForm(@RequestParam("no") int no,
                                  @RequestParam("colorNo") Integer colorNo,
                                  @RequestParam("imgNo") Integer imgNo,
                                  @RequestParam("url") String url,
                                  Model model) {

        List<Image> images = adminService.getImageByColorNo(colorNo);

        model.addAttribute("images", images);

        adminService.getNullImageThumbyimgNo(imgNo);

        adminService.getThumbnailByNo(imgNo);

        return "redirect:/admin/product/detail?no=" + no + "&colorNo=" + colorNo;
    }

    @GetMapping("/image-register")
    public String getRegisterImage(@RequestParam("no") int no,
                                   Model model) {


        Product product = adminService.getProductNo(no);
        List<Color> colors = adminService.getColorName(no);

        model.addAttribute("colors", colors);
        model.addAttribute("product", product);

        return "admin/product/image-register-form";
    }

    @PostMapping("/image-register")
    public String registerImage(@ModelAttribute ColorThumbnailForm form,
                                @RequestParam("image[]") List<String> links,  // 이미지 URL 배열로 받기
                                RedirectAttributes redirectAttributes) {

        try {
            adminService.addThumb(form, links);
            redirectAttributes.addFlashAttribute("successMessage", "이미지가 등록되었습니다.");
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("errorMessage", "이미지 등록 중 오류가 발생했습니다.");
        }

        return "redirect:/admin/image-register?no=" + form.getProdNo() + "&colorNo=" + form.getColorNo();
    }

    @GetMapping("/color-register")
    public String getRegisterColor(@RequestParam("no") int no,
                                   Model model) {

        ProdDetailDto prodDetailDto = productService.getProductByNo(no);
        model.addAttribute("prodDetailDto", prodDetailDto);

        return "admin/product/color-register-form";
    }

    @PostMapping("/color-register")
    public String registerColor(@RequestParam(name="no", required = false) Integer no,
                                @RequestParam(name="name", required = false) String name,
                                RedirectAttributes redirectAttributes,
                                Model model) {
        if (no == null || name == null || name.isEmpty()) {
            redirectAttributes.addFlashAttribute("errorMessage", "상품 번호와 색상은 필수 입력 값입니다.");
            return "redirect:/admin/register-color?no=" + no;
        }

        Map<String, Object> condition = new HashMap<>();
        condition.put("no", no);
        condition.put("name", name);

        model.addAttribute("condition", condition);
        adminService.addColor(condition);

        int colorNo = adminService.getColor(condition);

        redirectAttributes.addFlashAttribute("successMessage", "등록되었습니다.");

        return "redirect:/admin/product/color-register?no=" + condition.get("no") + "&colorNo=" + colorNo;
    }

    @GetMapping("/detail")
    public String productAdminDetail(@RequestParam("no") int no,
                                     @RequestParam("colorNo") int colorNo,
                                     Model model) {

        ProdDetailDto prodDetailDto = productService.getProductByNo(no);
        model.addAttribute("prodDetailDto", prodDetailDto);

        List<ColorProdImgDto> colorProdImgDto = productService.getProdImgByColorNo(no);
        model.addAttribute("colorProdImgDto", colorProdImgDto);

        SizeAmountDto sizeAmountDto = productService.getSizeAmountByColorNo(colorNo);
        model.addAttribute("sizeAmountDto", sizeAmountDto);

        ProdImagesDto prodImagesDto = productService.getProdImagesByColorNo(colorNo);
        model.addAttribute("prodImagesDto", prodImagesDto);

        Color color = adminService.getColorNo(colorNo);

        model.addAttribute("color", color);

        return "admin/product/detail";
    }


    @GetMapping("/register-form")
    public String productRegisterForm() {

        return "admin/product/register-form";
    }

    @PostMapping("/register-form")
    public String productRegisterForm(ProductRegisterForm form, Model model) {

        adminService.addProduct(form);

        Category category = adminService.getCategory(form.getCategoryNo());

        return "redirect:/admin/product/list?topNo=" + category.getTopNo();
    }
}
