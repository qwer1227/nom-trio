<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@include file="/WEB-INF/views/common/tags.jsp" %>
<!doctype html>
<html lang="ko">
<head>
    <%@include file="/WEB-INF/views/common/common.jsp" %>

    <style>
        /* 폼의 너비를 제한하고, 중앙 정렬 */
        .form-container {
            max-width: 600px; /* 최대 너비 설정 */
            margin: 0 auto; /* 중앙 정렬 */
        }
    </style>
</head>
<body>
<%@include file="/WEB-INF/views/common/nav.jsp" %>
<div class="container-xxl text-center" id="wrap">
    <h2>내 정보 수정</h2>

    <div class="form-container">
        <form action="/mypage/verify-password" method="post" class="form-group">
            <!-- 비밀번호 -->
            <div class="mb-3">
                <label for="password" class="form-label">비밀번호</label>
                <input type="password" id="password" name="password" class="form-control" placeholder="현재 비밀번호" required>
            </div>
            <!-- 수정 버튼 -->
            <button type="submit" class="btn btn-primary">제출하기</button>
        </form>
    </div>
</div>

<%@include file="/WEB-INF/views/common/footer.jsp" %>
</body>
</html>
