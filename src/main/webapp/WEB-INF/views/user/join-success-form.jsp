<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@include file="/WEB-INF/views/common/tags.jsp" %>
<!doctype html>
<html lang="ko">
<head>
    <%@include file="/WEB-INF/views/common/common.jsp" %>
    <title>아이디 찾기 폼</title>
</head>
<body>
<!-- 헤더부 -->
<header>
    <c:set var="menu" value="home"/>
    <%@include file="/WEB-INF/views/common/nav.jsp" %>
</header>

<!-- 메인 컨텐츠부 -->
<main class="container">
    <div class="container mt-5">
        <div class="login-form mx-auto text-center" style="max-width: 400px;">
            <!-- 아이디 찾기 제목 -->
            <div class="border p-2 bg-dark text-white fw-bold mb-3">회원가입 완료</div>

            <!-- 회원가입 완료 메시지 -->
            <div class="mb-3">
                <div class="row">
                    <h6>회원가입이 완료되었습니다.</h6>
                </div>
            </div>

            <!-- 버튼들: 홈으로, 로그인 -->
            <div class="mt-4">
                <a href="/home" class="btn btn-outline-dark me-2">홈으로</a>
                <a href="/user/login-form" class="btn btn-dark">로그인</a>
            </div>
        </div>
    </div>
</main>

<!-- 푸터부 -->
<footer>
    <%@include file="/WEB-INF/views/common/footer.jsp" %>
</footer>

</body>
</html>
