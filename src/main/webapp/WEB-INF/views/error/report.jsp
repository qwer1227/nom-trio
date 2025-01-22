<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@include file="/WEB-INF/views/common/tags.jsp" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <%@include file="/WEB-INF/views/common/common.jsp" %>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>관리자에 의해 삭제된 게시글입니다.</title>
</head>
<body>
<%@include file="/WEB-INF/views/common/nav.jsp" %>
<div class="container-xxl text-center align-content-center" id="wrap">
    <div class="row">
        <h1 class="text-primary">잘못된 접근</h1>
        <p class="">관리자에 의해 삭제된 게시글입니다.</p>
        <p class="text-muted">입력한 주소를 확인하시거나, 아래 버튼을 클릭해 홈으로 돌아가주세요.</p>
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
