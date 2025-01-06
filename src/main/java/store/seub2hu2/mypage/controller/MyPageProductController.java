package store.seub2hu2.mypage.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import store.seub2hu2.address.service.AddressService;
import store.seub2hu2.cart.dto.CartItemDto;
import store.seub2hu2.cart.dto.CartRegisterForm;
import store.seub2hu2.cart.vo.Cart;
import store.seub2hu2.mypage.dto.OrderResponse;
import store.seub2hu2.mypage.dto.ResponseDTO;
import store.seub2hu2.mypage.service.CartService;
import store.seub2hu2.mypage.service.WishListService;
import store.seub2hu2.order.service.OrderService;
import store.seub2hu2.product.service.ProductService;
import store.seub2hu2.product.vo.Color;
import store.seub2hu2.product.vo.Product;
import store.seub2hu2.product.vo.Size;
import store.seub2hu2.security.user.LoginUser;
import store.seub2hu2.user.vo.Addr;
import store.seub2hu2.user.vo.User;
import store.seub2hu2.wish.dto.WishItemDto;
import store.seub2hu2.wish.vo.WishList;

import java.util.ArrayList;
import java.util.List;

@Controller
@RequestMapping("/mypage")
public class MyPageProductController {

    @Autowired
    CartService cartService;

    @Autowired
    AddressService addressService;

    @Autowired
    ProductService productService;

    @Autowired
    WishListService wishListService;

    @Autowired
    OrderService orderService;

    @PostMapping("/delete")
    public String deleteItem(@RequestParam("cartNo") List<Integer> cartNoList) {

        cartService.deleteCartItems(cartNoList);

        return "redirect:/mypage/cart";
    }

    // Post 방식으로
    @PostMapping("/cart")
    public String addCart(@RequestParam("sizeNo") List<Integer> sizeNo
            , @RequestParam("prodNo") List<Integer> prodNo
            , @RequestParam("stock") List<Integer> stock
            , @RequestParam("colorNo") List<Integer> colorNo
            , @AuthenticationPrincipal LoginUser loginUser) {

        // CartRegisterForm
        List<CartRegisterForm> cartRegisterForms = new ArrayList<>();

        for (int i = 0; i < sizeNo.size(); i++) {
            int size = sizeNo.get(i);
            int prod = prodNo.get(i);
            int color = colorNo.get(i);
            int amount = stock.get(i);

            CartRegisterForm cartRegisterForm = new CartRegisterForm();
            cartRegisterForm.setSizeNo(size);
            cartRegisterForm.setProdNo(prod);
            cartRegisterForm.setColorNo(color);
            cartRegisterForm.setStock(amount);

            User user = User.builder().no(loginUser.getNo()).build();
            cartRegisterForm.setUserNo(user.getNo());

            cartRegisterForms.add(cartRegisterForm);
        }

        cartService.addCart(cartRegisterForms);

        return "redirect:cart";
    }

    @PostMapping("/add-to-cart")
    @ResponseBody
    public String addToCart(@RequestParam("wishNo") int wishNo
            ,@RequestParam("prodNo") int prodNo
            ,@RequestParam("colorNo") int colorNo
            ,@RequestParam("sizeNo") int sizeNo
            ,@AuthenticationPrincipal LoginUser loginUser) {

        // 로그인된 사용자의 정보를 가져오기
        User user = User.builder().no(loginUser.getNo()).build();

        // 위시리스트에서 해당 상품을 찾고, 장바구니에 추가
        Cart cart = new Cart();
        cart.setUser(user);

        // Product, Color, Size 세팅
        Product product = new Product();
        product.setNo(prodNo);
        cart.setProduct(product);

        Color color = new Color();
        color.setNo(colorNo);
        cart.setColor(color);

        Size size = new Size();
        size.setNo(sizeNo);
        cart.setSize(size);

        cartService.addToCart(cart);

        wishListService.deleteWishListItemByNo(wishNo);

        return "redirect:/cart";
    }

    @PostMapping("/delete-wish")
    @ResponseBody
    public String deleteWish(@RequestParam("wishNo") int wishNo) {

        // 삭제
        wishListService.deleteWishListItemByNo(wishNo);
        return "삭제 성공";
    }

    // Post 방식으로
    @PostMapping("/wish")
    public String addWish(@RequestParam("sizeNo") List<Integer> sizeNo
            ,@RequestParam("prodNo") List<Integer> prodNo
            ,@RequestParam("colorNo") List<Integer> colorNo
            ,@AuthenticationPrincipal LoginUser loginUser
            , Model model){

        List<WishList> wishLists = new ArrayList<>();

        for (int i = 0; i < sizeNo.size(); i++) {
            WishList wish = new WishList();

            // Product 설정
            Product product = new Product();
            product.setNo(prodNo.get(i));
            wish.setProduct(product);

            // Color 설정
            Color color = new Color();
            color.setNo(colorNo.get(i));
            wish.setColor(color);

            // Size 설정
            Size size = new Size();
            size.setNo(sizeNo.get(i));
            wish.setSize(size);

            // User 설정
            User user = User.builder().no(loginUser.getNo()).build();
            wish.setUser(user);

            // WishList에 추가
            wishLists.add(wish);
        }

        // Service로 데이터 전달
        wishListService.insertWishItems(wishLists);

        return "redirect:wish";
    }

    // 주문내역-상세 화면으로 간다
    @GetMapping("/orderhistorydetail/{orderNo}")
    public String orderHistoryDetail(@PathVariable("orderNo") int orderNo, Model model, @AuthenticationPrincipal LoginUser loginUser) {

        ResponseDTO order = orderService.getOrderDetails(orderNo);

        double totalPrice = order.getOrders().getOrderPrice()-order.getOrders().getDisPrice();

        model.addAttribute("order", order);
        model.addAttribute("totalPrice", totalPrice);

        return "mypage/orderhistorydetail";
    }

    // 주문결제 화면으로 간다.
    @GetMapping("/order")
    public String order() {

        return "mypage/order";
    }

    // Post 방식으로 주문결제 화면으로 간다.
    @PostMapping("/order")
    public String addOrder(@RequestParam("sizeNo") List<Integer> sizeNoList
            ,@RequestParam("stock") List<Integer> stock
            , @AuthenticationPrincipal LoginUser loginUser
            ,Model model) {

        List<CartItemDto> orderItems = orderService.getOrderItemBySizeNo(sizeNoList, stock, loginUser.getNo());
        model.addAttribute("orderItems", orderItems);

        List<Addr> addresses = addressService.getAddressListByUserNo(loginUser.getNo());
        model.addAttribute("addresses", addresses);

        return "mypage/order";
    }

}
