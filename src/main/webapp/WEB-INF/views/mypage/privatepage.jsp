<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ include file="/WEB-INF/views/common/tags.jsp" %>
<!doctype html>
<html lang="ko">
<head>
    <%@ include file="/WEB-INF/views/common/common.jsp" %>
    <style>
        /* a 태그에 밑줄 없애기*/
        a {
            color: black;
            text-decoration-line: none;
        }
        /* 전체 컨테이너 중앙 정렬 */
        #wrap {
            display: flex;
            justify-content: center;
            align-items: center;
            height: 100vh;
        }

        /* 직사각형을 위한 스타일 */
        .rectangle {
            width: 300px; /* 직사각형 너비 */
            height: auto; /* 자동으로 높이 조정 */
            background-color: #f8f9fa;
            padding: 20px;
            border-radius: 10px;
            box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1); /* 그림자 효과 */
            display: flex;
            flex-direction: column;
            justify-content: flex-start; /* 항목들을 위에서부터 차례대로 배치 */
            align-items: center; /* 항목들을 가로로 중앙 정렬 */
            gap: 15px; /* 항목 간의 간격 */
        }

        /* 각 항목을 담는 div 스타일 */
        .item {
            background-color: #e9ecef;
            padding: 15px;
            width: 90%; /* 직사각형 크기보다 살짝 작은 너비 */
            text-align: center;
            border-radius: 8px;
            font-size: 16px;
            box-sizing: border-box; /* 패딩이 항목 크기에 포함되도록 설정 */
        }

        .item:hover {
            background-color: #dee2e6; /* 마우스 오버시 색상 변경 */
        }
    </style>
</head>
<body>
<%@ include file="/WEB-INF/views/common/nav.jsp" %>

<div class="container-xxl text-center" id="wrap">
    <div class="rectangle">
        <div class="item">
            <h3><a href="/mypage/verify-password" id="edit">내정보변경</a></h3>
        </div>
        <div class="item">
            <h3><a href="/mypage/history?type=value1" id="history">활동기록</a></h3>
        </div>
        <div class="item">
            <h3><a href="/mypage/cart">장바구니</a></h3>
        </div>
        <div class="item">
            <h3><a href="/mypage/wish">위시리스트</a></h3>
        </div>
        <div class="item">
            <h3><a href="/mypage/orderhistory">주문내역</a></h3>
        </div>
        <div class="item">
            <h3><a href="/mypage/qna">문의내역</a></h3>
        </div>
        <div class="item">
            <h3><a href="/mypage/workout">운동일지</a></h3>
        </div>
        <div class="item">
            <h3><a href="/mypage/participatingcrew">참여크루</a></h3>
        </div>
        <div class="item">
            <h3><a href="/lesson/reservation">레슨예약내역</a></h3>
        </div>
    </div>
</div>

<%@ include file="/WEB-INF/views/common/footer.jsp" %>
</body>
</html>
