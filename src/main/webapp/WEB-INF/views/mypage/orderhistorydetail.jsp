<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@include file="/WEB-INF/views/common/tags.jsp" %>
<!doctype html>
<html lang="ko">
<head>
  <%@include file="/WEB-INF/views/common/common.jsp" %>
  <style>
    body {
      font-family: Arial, sans-serif;
      background-color: #f8f9fa;
      margin: 0;
      padding: 0;
    }

    #wrap {
      width: 90%;
      max-width: 1200px;
      margin: 30px auto;
      background-color: #fff;
      padding: 20px;
      border-radius: 10px;
      box-shadow: 0 4px 10px rgba(0, 0, 0, 0.1);
    }

    h2 {
      font-size: 24px;
      margin-bottom: 20px;
    }

    .order-info, .payment-info, .benefit-info {
      margin-bottom: 30px;
    }

    .info-title {
      font-size: 18px;
      font-weight: bold;
      margin-bottom: 10px;
    }

    .info-content {
      font-size: 16px;
      line-height: 1.6;
    }

    .info-content p {
      margin: 5px 0;
    }

    .info-content span {
      font-weight: bold;
    }

    .product-list {
      border-top: 1px solid #ddd;
      padding-top: 20px;
    }

    .product-item {
      display: flex;
      align-items: center;
      margin-bottom: 20px;
    }

    .product-item img {
      width: 80px;
      height: 80px;
      object-fit: cover;
      border: 1px solid #ddd;
      margin-right: 20px;
    }

    .product-details {
      flex-grow: 1;
    }

    .product-details p {
      margin: 5px 0;
      font-size: 16px;
    }

    .product-details span {
      font-weight: bold;
    }

    .btn-group {
      display: flex;
      gap: 10px;
      margin-top: 10px;
    }

    .btn {
      padding: 8px 12px;
      border-radius: 4px;
      text-decoration: none;
      font-size: 14px;
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

    .btn-tracking {
      background-color: #3498db;
      color: white;
    }

    .btn-tracking:hover {
      background-color: #2980b9;
    }

    .btn-repurchase {
      background-color: #e67e22;
      color: white;
    }

    .btn-repurchase:hover {
      background-color: #d35400;
    }
  </style>
</head>
<body>
<%@include file="/WEB-INF/views/common/nav.jsp" %>

<div id="wrap">
  <h2>주문 상세 정보</h2>

  <!-- 주문 정보 -->
  <div class="order-info">
    <div class="info-title">주문 정보</div>
    <div class="info-content">
      <p><span>주문일:</span> <fmt:formatDate value="${order.orders.orderDate}" pattern="yyyy-MM-dd" timeZone="Asia/Seoul"/></p>
      <p><span>주문번호:</span> ${order.orders.orderId}</p>
      <p><span>받는 사람:</span> ${order.addrDto.addrName}</p>
      <p><span>배송 주소:</span> ${order.addrDto.addr}</p>
      <p><span>연락처:</span> ${order.orders.receiverPhone}</p>
    </div>
  </div>

  <!-- 주문 상품 -->
<div class="product-list">
    <div class="info-title">주문 상품</div>
    <c:forEach var="item" items="${order.products}">
        <div class="product-item">
            <img src="${item.prodImgUrl}" alt="상품 이미지">
            <div class="product-details d-flex justify-content-between align-items-center">
                <div>
                    <p class="d-flex justify-content-between align-items-center">
                        <span>상품명:</span>
                        <span>${item.prodName}</span>
                        <!-- 배송 상태 -->
                        <span class="delivery-status text-muted ms-auto" style="padding: 10px">${item.orderStatus}</span>
                    </p>
                    <p><span>옵션:</span> ${item.sizeName} / ${item.colorName}</p>
                    <p><span>수량:</span> ${item.orderQty}개</p>
                    <p><span>가격:</span> ${item.prodPrice}원</p>
                </div>
                <div class="btn-group">
                    <a href="/mypage/reviews/${item.prodNo}" class="btn btn-reviews">후기 작성</a>
                    <a href="/mypage/tracking/${item.prodNo}" class="btn btn-tracking">배송 조회</a>
                </div>
            </div>
        </div>
    </c:forEach>
</div>


  <!-- 결제 정보 -->
  <div class="payment-info">
    <div class="info-title">결제 정보</div>
    <div class="info-content">
      <p><span>상품 금액:</span>
   <fmt:formatNumber value="${order.orders.orderPrice}" pattern="#,###" />원
</p>
<p><span>할인 금액:</span>
   <fmt:formatNumber value="${order.orders.disPrice}" pattern="#,###" />원
</p>
<p><span>배송비:</span>
   <fmt:formatNumber value="${order.orders.delPayment}" pattern="#,###" />원
</p>
<p><span>결제 금액:</span>
   <fmt:formatNumber value="${totalPrice}" pattern="#,###" />원
</p>
<p><span>결제 방법:</span> ${order.payments.payMethod}</p>
    </div>
  </div>
</div>

<%@include file="/WEB-INF/views/common/footer.jsp" %>
</body>
</html>
