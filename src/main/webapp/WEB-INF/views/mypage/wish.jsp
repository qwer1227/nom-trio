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

    <div class="row m-5">
        <h2>위시리스트</h2>
    </div>
    <hr class="bg-primary border border-1">
    <form id="addToCart" action="/add-to-cart" method="post">
        <div class="row row-cols-1 row-cols-md-3 g-4 mt-5 mb-5">
            <c:forEach var="item" items="${wishItemDtoList}">
                <input type="hidden" name="prodNo"  value="${item.product.no}"/>
                <input type="hidden" name="sizeNo" value="${item.size.no}"/>
                <input type="hidden" name="colorNo"  value="${item.color.no}"/>
                <div class="col">
                    <div class="card h-100">
                        <a class="text-decoration-none" href="/product/detail?no=${item.product.no}&colorNo=${item.color.no}">
                        <c:forEach var="img" items="${item.images}">
                            <img src="${img.url}" class="card-img-top" alt="...">
                        </c:forEach>
                        </a>
                        <div class="card-body">
                            <h5 class="card-title">${item.product.name}</h5>
                            <h5>[${item.color.name}/${item.size.size}]</h5>
                            <div>
                                <p>${item.category.name}</p>
                                <p><strong><fmt:formatNumber value="${item.product.price}"/> 원</strong></p>
                            </div>
                            <hr class="bg-primary border border-1">
                            <button type="button" class="btn btn-outline-secondary" id="addToCartBtn"
                                    data-wishno="${item.no}"
                                    data-prodno="${item.product.no}"
                                    data-colorno="${item.color.no}"
                                    data-sizeno="${item.size.no}">
                                <i class="bi bi-basket-fill"></i>
                            </button>
                            <button type="button" class="btn btn-outline-secondary" id="deleteBtn" data-wishNo="${item.no}">
                                <i class="bi bi-trash3-fill"></i>
                            </button>

                        </div>
                    </div>
                </div>
            </c:forEach>
        </div>
    </form>
</div>
<script>
    // 장바구니 추가 버튼 할시
    $(document).ready(function() {
        $('#addToCartBtn').click(function() {
            // 버튼에 저장된 데이터를 가져옵니다.
            const wishNo = $(this).data('wishno');
            const prodNo = $(this).data('prodno');
            const colorNo = $(this).data('colorno');
            const sizeNo = $(this).data('sizeno');

            if (!wishNo || !prodNo || !colorNo || !sizeNo) {
                alert('데이터가 부족합니다. 확인해주세요.');
                return;
            }

            // 장바구니에 추가할 데이터를 서버로 전달하는 AJAX 요청
            $.ajax({
                url: '/mypage/add-to-cart',  // 장바구니 추가를 처리할 서버 URL
                type: 'POST',
                data: {
                    wishNo: wishNo,
                    prodNo: prodNo,
                    colorNo: colorNo,
                    sizeNo: sizeNo
                },
                success: function(response) {
                    alert('장바구니에 추가되었습니다.');
                    // 성공적으로 추가된 후 UI 변경 (예: 버튼 상태 변경)
                    location.reload();
                },
                error: function(error) {
                    alert('장바구니 추가에 실패했습니다.');
                }
            });
        });
    });


    // 삭제버튼 클릭시
    $(document).ready(function() {
        $('#deleteBtn').click(function() {
            const wishNo = $(this).data('wishno');  // 삭제하려는 wishNo를 가져옴

            if (confirm('정말로 삭제하시겠습니까?')) {
                // ajax 요청 보내기
                $.ajax({
                    url: '/mypage/delete-wish',  // 삭제를 처리할 서버 URL
                    type: 'POST',
                    data: {
                        wishNo: wishNo
                    },
                    success: function(response) {
                        alert('삭제 완료');
                        location.reload();  // 페이지를 새로 고침하여 삭제된 항목을 반영
                    },
                    error: function(error) {
                        alert('삭제 실패');
                    }
                });
            }
        });
    });
</script>

<%@include file="/WEB-INF/views/common/footer.jsp" %>
</body>
</html>
