<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@include file="/WEB-INF/views/common/tags.jsp" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>500 - 내부 서버 오류</title>
    <%@include file="/WEB-INF/views/common/common.jsp" %>
</head>
<body>
<%@include file="/WEB-INF/views/common/nav.jsp" %>
<div class="container-xxl text-center align-content-center" id="wrap">
    <div class="row">
        <h1 class="text-primary">500</h1>
        <p class="">서버에 문제가 발생했습니다.</p>
        <p class="text-muted">잠시 후 다시 시도하시거나, 문제가 지속될 경우 관리자에게 문의하세요.</p>
    </div>
    <div class="row justify-content-center">
        <div class="col">
            <a href="/home" class="btn btn-primary mt-3 w-25">홈으로 돌아가기</a>
        </div>
    </div>
</div>
<%@include file="/WEB-INF/views/common/footer.jsp" %>
</body>
</html>
