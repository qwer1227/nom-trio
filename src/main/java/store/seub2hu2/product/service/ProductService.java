package store.seub2hu2.product.service;

import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import store.seub2hu2.product.dto.*;
import store.seub2hu2.product.mapper.ProductMapper;
import store.seub2hu2.product.vo.Product;
import store.seub2hu2.util.ListDto;
import store.seub2hu2.util.Pagination;

import java.util.List;
import java.util.Map;

@Slf4j
@Service
@Transactional
public class ProductService {

    @Autowired
    ProductMapper productMapper;

    public void updateProdDetailViewCnt(int prodNo, int colorNo) {
         Product product = productMapper.getProductByProdNoAndColoNo(prodNo, colorNo);
         product.setCnt(product.getCnt() + 1);
         productMapper.incrementViewCount(product);
    }

    /**
     * 색상 번호에 따른 다양한 이미지 조회하기
     * @param colorNo 색상 번호
     * @return 해당 상품의 하나의 색상의 여러 이미지들 값
     */
    public ProdImagesDto getProdImagesByColorNo(int colorNo) {

        ProdImagesDto prodImagesDto = productMapper.getProdImagesByColorNo(colorNo);

        return prodImagesDto;
    }

    /**
     * 색상 번호에 따른 사이즈와 재고량 조회하기
     * @param colorNo 색상 번호
     * @return 사이즈와 재고수량
     */
    public SizeAmountDto getSizeAmountByColorNo(int colorNo) {

        SizeAmountDto getSizeAmount = productMapper.getSizeAmountByColorNo(colorNo);

        return getSizeAmount;
    }

    /**
     * 상품 번호에 따른 다양한 색 그리고 여러 이미지 중 대표 이미지 조회하기
     * @param no 상품 번호
     * @return 다양한 색, 대표 이미지 하나
     */
    public List<ColorProdImgDto> getProdImgByColorNo(int no) {

        List<ColorProdImgDto> colorImgByNo = productMapper.getProdImgByColorNo(no);

        return colorImgByNo;
    }

    /**
     * 개별 상품 정보 조회
     * @param no 상품 번호
     * @return 상품 상세 정보
     */
    public ProdDetailDto getProductByNo(int no) {

        ProdDetailDto prodDetailDto = productMapper.getProductByNo(no);

        return prodDetailDto;
    }

    /**
     * 모든 상품정보 목록을 제공하는 서비스 메서드입니다.
     * @param condition 조회조건이 포함된 MAP 객체입니다.
     * @return 모든 상품 목록
     */
    public ListDto<ProdListDto> getProducts(Map<String, Object> condition) {

        // 검색 조건에 맞는 전체 데이터 갯수를 조회하는 기능
        int totalRows = productMapper.getTotalRows(condition);

        // Pagination 객체를 생성한다.
        int page = (Integer) condition.get("page");
        int rows = (Integer) condition.get("rows");

        Pagination pagination = new Pagination(page, totalRows, rows);

        // 데이터 검색 범위를 조회해서 Map에 저장한다.
        condition.put("begin", pagination.getBegin());
        condition.put("end", pagination.getEnd());

        // ProdListDto 타입의 데이터를 담는 ListDto 객체를 생성한다.
        // 상품 목록 ListDto(ProdListDto), 페이정처리 정보(Pagination)을 담는다.
        List<ProdListDto> products = productMapper.getProducts(condition);
        System.out.println(products.toString());
        ListDto<ProdListDto> dto = new ListDto<>(products, pagination);

        return dto;
    }

}
