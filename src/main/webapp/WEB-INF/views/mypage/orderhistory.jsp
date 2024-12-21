<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@include file="/WEB-INF/views/common/tags.jsp" %>
<!doctype html>
<html lang="ko">
<head>
    <%@include file="/WEB-INF/views/common/common.jsp" %>
    <style>
        body {
            font-family: 'Arial', sans-serif;
            background-color: #f8f9fa;
            margin: 0;
            padding: 0;
        }

        #wrap {
            width: 90%;
            max-width: 1200px;
            margin: 30px auto;
        }

        .order-list {
            border-collapse: collapse;
            width: 100%;
            background-color: #ffffff;
            border-radius: 10px;
            box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
            overflow: hidden;
        }

        .order-list thead {
            background-color: #3498db;
            color: #ffffff;
            text-align: left;
        }

        .order-list th, .order-list td {
            padding: 15px;
            font-size: 14px;
        }

        .order-list th {
            font-weight: bold;
        }

        .order-list tbody tr:nth-child(even) {
            background-color: #f9f9f9;
        }

        .order-list tbody tr:hover {
            background-color: #f1f1f1;
        }

        .order-list img {
            width: 50px;
            height: 50px;
            object-fit: cover;
            border-radius: 4px;
        }

        .btn {
            padding: 8px 12px;
            border-radius: 4px;
            text-decoration: none;
            font-size: 12px;
            cursor: pointer;
            text-align: center;
        }

        .btn-reviews {
            background-color: #2ecc71;
            color: white;
        }

        .btn-reviews:hover {
            background-color: #27ae60;
        }

        .btn-cancel {
            background-color: #e74c3c;
            color: white;
        }

        .btn-cancel:hover {
            background-color: #c0392b;
        }

        /* 주문번호 중앙 정렬 */
        .order-no {
            text-align: center;
        }

        /* 주문번호 링크 스타일 */
        .order-no a {
            color: #3498db;
            text-decoration: none;
            font-weight: bold;
        }

        .order-no a:hover {
            text-decoration: underline;
        }
    </style>
</head>
<body>
<%@include file="/WEB-INF/views/common/nav.jsp" %>

<div id="wrap">
    <div class="mb-3">
        <h2>주문 내역</h2>
    </div>
    <form method="post" action="/pay/cancel" id="cancelForm">
        <input type="hidden" name="type" value="상품" />

        <table class="order-list">
            <thead>
                <tr>
                    <th>주문번호</th>
                    <th>이미지</th>
                    <th>상품명</th>
                    <th>가격</th>
                    <th>총 주문 수량</th>
                    <th>주문상태</th>
                    <th>배송상태</th>
                    <th>리뷰</th>
                </tr>
            </thead>
            <tbody>
                <c:forEach var="order" items="${orders}">
                    <tr>
                        <!-- 주문번호 -->
                        <td class="order-no">
                            <a href="/mypage/orderhistorydetail/${order.orderNo}">
                                ${order.orderId}
                            </a>
                        </td>
                        <td><img src="${order.productImage}" alt="상품 이미지"></td>
                        <td>${order.productName}</td>
                        <td><fmt:formatNumber>${order.productPrice}</fmt:formatNumber> 원</td>
                        <td>${order.quantity} 개</td>
                        <td>${order.orderStatus}</td>
                        <td>${order.deliveryStatus}</td>
                        <td>
                            <a href="/product/detail?no=${order.productNo}&colorNo=${order.colorNo}" class="btn btn-reviews">리뷰작성</a>
                            <button type="button" class="btn btn-cancel" onclick="confirmCancel(${order.orderNo})">
                                주문취소
                            </button>
                        </td>
                    </tr>
                </c:forEach>
            </tbody>
        </table>
        <input type="hidden" name="orderNo" id="orderNo">
    </form>
</div>
<script>
    function confirmCancel(orderNo) {
        const confirmResult = confirm("주문을 취소하시겠습니까?");
        if (confirmResult) {
            // 숨겨진 필드에 주문 번호 설정
            document.getElementById("orderNo").value = orderNo;
            // 폼 제출
            document.getElementById("cancelForm").submit();
        }
    }
</script>

<%@include file="/WEB-INF/views/common/footer.jsp" %>
</body>
</html>
