<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@include file="/WEB-INF/views/common/tags.jsp" %>
<!doctype html>
<html lang="ko">
<head>
    <%@include file="/WEB-INF/views/common/common.jsp" %>
</head>
<body>
<%@include file="/WEB-INF/views/common/nav.jsp" %>
<div class="container-xxl text-center" id="wrap">
    <!--
        장바구니에 아무것도 없다면
    -->
    <c:if test="${empty cartItemDtoList}">
        <div class="row m-5">
            <h2>장바구니</h2>
            <hr class="bg-primary border border-1">
            <p>장바구니가 비어있습니다.</p>
        </div>
    </c:if>

    <c:if test="${!empty cartItemDtoList}">
        <div class="row m-5">
            <h2 id="total-kind">장바구니 (${qty} 개 상품)</h2>
            <p>장바구니에 담긴 상품은 30일동안 보관됩니다.</p>
        </div>
        <hr class="bg-primary border border-1">
        <div class="row mb-3 d-flex align-items-center justify-content-between">
            <div class="col">
                <div class="text-start">
                    <input id="total-checked" type="checkbox" style="zoom:1.8">
                </div>
            </div>
            <div class="col-auto mn-3">
                <button type="button" class="btn btn-lg" id="delete-item">
                    <i class="bi bi-trash"></i> 선택 삭제
                </button>
            </div>
            <div class="row">
                <div class="col-12">
                    <form id="form-order" method="post">
                    <table class="table align-middle mt-2 md-2">
                        <colgroup>
                            <col width="5%"/>
                            <col width="15%"/>
                            <col width="30%"/>
                            <col width="30%"/>
                            <col width="20%">
                        </colgroup>
                        <tbody>
                            <c:forEach var="item" items="${cartItemDtoList}">

                                <tr>
                                    <td>
                                        <input id="each-checked-${item.no}" type="checkbox" style="zoom: 1.5"/>
                                    </td>
                                    <td>
                                        <img src="${item.imgThum}" class="rounded mx-auto d-block" width="170">
                                    </td>
                                    <td>
                                        <input type="hidden" name="cartNo" value="${item.no}">
                                        <input type="hidden" name="prodNo" value="${item.product.no}"/>
                                        <input type="hidden" name="colorNo" value="${item.color.no}"/>
                                        <input type="hidden" name="sizeNo" value="${item.size.no}"/>
                                        <span>${item.product.name}</span>
                                        <p>[${item.color.name}/${item.size.size}]</p>
                                    </td>
                                    <td>
                                        <input type="button" value=" - " name="minus" data-no="${item.no}">
                                        <input type="text" name="stock" value="${item.stock}" id="stock-${item.no}" size="3" max="" style=" width: 3rem; text-align: center">
                                        <input type="button" value=" + " name="plus" data-no="${item.no}">
                                    </td>
                                    <td>
                                        <span><strong id="price-${item.no}" data-price="${item.product.price}"><fmt:formatNumber value="${item.product.price * item.stock}"/></strong> 원</span>
                                    </td>
                                </tr>

                            </c:forEach>
                        </tbody>
                    </table>
                    </form>
                </div>
            </div>

    </c:if>
        <!--
            총 금액과 주문하기 버튼
        -->
        <div class="row">
            <div class="col-8">
                <table class="table table-borderless">
                    <colgroup>
                        <col width="50%">
                        <col width="50%">
                    </colgroup>
                    <thead class="table-secondary">
                        <tr class="text-start">
                            <th colspan="2">주문예정 금액</th>
                        </tr>
                    </thead>
                    <tbody>
                        <tr>
                            <td class="text-start">상품금액</td>
                            <td class="text-end" id="total-price">0 원</td>
                        </tr>
                        <tr>
                            <td class="text-start">배송비</td>
                            <td class="text-end" id="delivery-price">0 원</td>
                        </tr>
                        <tr>
                            <td></td>
                            <td class="text-end text-secondary" style="font-size: 15px;">50,000원 이상 구매 시 무료 배송</td>
                        </tr>
                    </tbody>
                </table>
            </div>
            <div class="col-4">
                <div class="bg-light p-4 mb-2">
                    <p><strong class="fs-3">총 결제금액</strong></p>
                    <p><strong class="text-danger fs-2" id="final-total-price">0</strong> 원</p>
                </div>
                <div class="d-grid gap-2">
                    <button class="btn btn-dark" id="order-add" type="button">주문하기 (<strong id="total-stock">0</strong>개)</button>
                </div>
            </div>
        </div>
    </div>
</div>
<script>

    $('input[name=minus]').on('click', function(){
        let no = $(this).attr("data-no");
        // 수량
        let amountInput = document.querySelector('#stock-' + no);
        let currentValue = parseInt(amountInput.value);

        if(currentValue > 1) {
            amountInput.value = currentValue - 1;
            updatePrice(no);
            updateTotals();
        }
    })

    $('input[name=plus]').on('click', function(){
        let no = $(this).attr("data-no");

        let amountInput = document.querySelector('#stock-' + no);
        let currentValue = parseInt(amountInput.value);
        amountInput.value = currentValue + 1;

        updatePrice(no);
        updateTotals();
    })

    const updatePrice = (no) => {
        // 수량
        let amountInput = document.querySelector('#stock-' + no);
        // 단가
        let eachPrice = document.querySelector('#price-'+ no);
        let value = eachPrice.dataset.price;
        let total = parseInt(value, 10);

        // 총액
        let quantity = parseInt(amountInput.value) || 1;
        let totalPrice = total * quantity;

        eachPrice.textContent = totalPrice.toLocaleString();
    }

    const updateTotals = () => {
        let totalPrice = 0; // 총 가격
        let totalStock = 0; // 총 갯수
        let deliveryPrice = 3000; // 배송비
        let finalTotalPrice = 0; // 최종가격(총 가격 + 배송비)

        let x = $("#form-order :checkbox:checked")
                    .closest("tr")
                    .find("strong[id^=price]").each(function () {

            let price = $(this).text().replaceAll(",", "");
            totalPrice += parseInt(price)
        })

        let y = $("#form-order :checkbox:checked")
            .closest("tr")
            .find("input[id^=stock]").each(function () {
            let stock = $(this).val();
            totalStock += parseInt(stock);
        });

        // 50000원 이상 구매시 배송비 무료
        if(totalPrice === 0) {
            deliveryPrice = 0;
        } else if (totalPrice >= 50000) {
            deliveryPrice = 0;
        }
        finalTotalPrice = totalPrice + deliveryPrice;

        // 화면 출력
        $("#total-stock").text(totalStock.toLocaleString())
        $("#delivery-price").text(deliveryPrice.toLocaleString());
        $("#total-price").text(totalPrice.toLocaleString() + ' 원');
        $("#final-total-price").text(finalTotalPrice.toLocaleString())
    }

    // 전체 클릭과 전체 해제 기능
    $("#total-checked").on('click', function () {

        let isChecked = $(this).prop('checked');
        $('input[id^="each-checked-"]').prop('checked', isChecked);
        updateTotals()
    });

    // 개별 선택 동작
    $('input[id^="each-checked-"]').on('change', function () {
        updateTotals();
        const totalCheckboxes = $('input[id^="each-checked-"]');
        const checkedCheckboxes = $('input[id^="each-checked-"]:checked');
        let allChecked = totalCheckboxes.length === checkedCheckboxes.length;

        $('#total-checked').prop('checked', allChecked);
    });

    // 주문결제에 전달
    $('#order-add').click(function () {
        $("#form-order table :checkbox:not(:checkbox:checked)").closest("tr").remove();
        $('#form-order').attr('action', '/mypage/order')
        $('#form-order').trigger('submit');
    });

    // 선택 삭제
    $('#delete-item').on('click', function (){
        $("#form-order table :checkbox:not(:checkbox:checked)").closest("tr").remove();
        $('#form-order').attr('action', '/mypage/delete')
        $('#form-order').trigger('submit');
    });

    //
</script>


<%@include file="/WEB-INF/views/common/footer.jsp" %>
</body>
</html>
