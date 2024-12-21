<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@include file="/WEB-INF/views/common/tags.jsp" %>
<!doctype html>
<html lang="ko">
<head>
    <style>
        .table th, .table td {
            border: none;
        }
    </style>

    <%@include file="/WEB-INF/views/common/common.jsp" %>
</head>
<body>
<%@include file="/WEB-INF/views/common/nav.jsp" %>
<div class="container-xxl text-center" id="wrap">

    <div class="row mb-3">
        <div>
            <h1>주문이 완료되었습니다.</h1>
        </div>
        <div>
            <h3>주문 번호: ${orderDetail.orderId}</h3>
        </div>
    </div>
    <div class="row mb-3">
        <div class="col">
            <table class="table align-middle mt-2 md-2">
                <colgroup>
                    <col width="50%"/>
                    <col width="55%">
                </colgroup>
                <thead class="table-secondary">
                <tr class="text-start">
                    <th colspan="3">주문상품 정보</th>
                </tr>
                </thead>
                <tbody>
                <c:forEach var="item" items="${orderDetail.items}">
                    <tr>
                        <th><label>주문 상품</label></th>
                        <td>${item.prodName}[${item.prodColor}/${item.prodSize}] ${item.orderProdAmount} 개  </td>
                    </tr>
                </c:forEach>
                    <tr id="totalQuantity">
                        <th><label>총 주문 수량</label></th>
                        <td id="qty">개</td>
                    </tr>
                </tbody>
            </table>
            <table class="table align-middle mt-2 md-2">
                <colgroup>
                    <col width="50%"/>
                    <col width="55%">
                </colgroup>
                <thead class="table-secondary">
                <tr class="text-start">
                    <th colspan="3">배송지 정보</th>
                </tr>
                </thead>
                <tbody>
                <tr>
                    <th><label>받으시는 분</label></th>
                    <td>${orderDetail.addrName}</td>
                </tr>
                <tr>
                    <th><label>우편번호</label></th>
                    <td>${orderDetail.postcode}</td>
                </tr>
                <tr>
                    <th><label>배송지</label></th>
                    <td>${orderDetail.addr} ${orderDetail.addrDetail}</td>
                </tr>
                <tr>
                    <th><label>휴대폰 번호</label></th>
                    <td>${orderDetail.delPhoneNumber}</td>
                </tr>
                </tbody>
            </table>
            <table class="table align-middle mt-2 md-2">
                <colgroup>
                    <col width="50%"/>
                    <col width="55%">
                </colgroup>
                <thead class="table-secondary">
                <tr class="text-start">
                    <th colspan="3">결제 정보</th>
                </tr>
                </thead>
                <tbody>
                <tr>
                    <th><label>결제 수단</label></th>
                    <td>${orderDetail.payMethod}</td>
                </tr>
                <tr>
                    <th><label>결제 금액</label></th>
                    <td><fmt:formatNumber>${orderDetail.realPrice}</fmt:formatNumber> 원</td>
                </tr>
                </tbody>
            </table>
            <table class="table align-middle mt-2 md-2">
                <colgroup>
                    <col width="50%"/>
                    <col width="55%">
                </colgroup>
                <thead class="table-secondary">
                <tr class="text-start">
                    <th colspan="3">배송 정보</th>
                </tr>
                </thead>
                <tbody>
                <tr>
                    <th><label>배송 상태</label></th>
                    <td>${orderDetail.delStatus}</td>
                </tr>
                <tr>
                    <th><label>배송 업체</label></th>
                    <td>${orderDetail.delCom}</td>
                </tr>
                <tr>
                    <th><label>배송 메모</label></th>
                    <td>${orderDetail.delMemo}</td>
                </tr>
                </tbody>
            </table>
        </div>
    </div>
    <a href="/mypage/orderhistory" class="col btn btn-dark" role="button">주문 내역으로</a>
</div>
<script>
    $(document).ready(function() {
        let totalQuantity = 0; // 총 수량을 저장할 변수

        // 각 주문 항목에 대해 수량을 가져와 합산
        $("tbody tr").each(function() {
            // 주문 상품의 수량 부분이 포함된 <td> 텍스트를 가져옴
            let orderProdAmountText = $(this).find("td").text().trim();
            let orderProdAmount = orderProdAmountText.match(/(\d+)\s*개/); // "개"와 함께 숫자 추출

            // 수량이 있는 경우만 처리
            if (orderProdAmount) {
                totalQuantity += parseInt(orderProdAmount[1]); // 숫자로 변환 후 합산
            }
        });

        // 계산된 총 수량을 #qty에 표시
        $("#qty").text(totalQuantity + " 개");
    });
</script>


<%@include file="/WEB-INF/views/common/footer.jsp" %>
</body>
</html>
