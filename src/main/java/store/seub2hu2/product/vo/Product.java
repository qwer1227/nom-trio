package store.seub2hu2.product.vo;

import lombok.*;

import java.util.Date;

@AllArgsConstructor
@NoArgsConstructor
@Setter
@Getter
@ToString
public class Product {

    private int no;
    private String name;
    private String content;
    private double price;
    private int stock;
    private int colorNum;
    private boolean isNew;
    private String status;
    private Date createdAt;
    private Date updatedAt;
    private String imgThum;
    private int cnt;
    private double rating;
    private Category category;
    private Size size;
    private Brand brand;
    private Color color;
    private String isShow;
}
