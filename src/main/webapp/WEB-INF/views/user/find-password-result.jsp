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
            <div class="border p-2 bg-dark text-white fw-bold mb-3">아이디 찾기 결과</div>

            <!-- 모달 -->
            <div class="modal fade show d-block" id="resultModal" tabindex="-1" aria-labelledby="resultModalLabel"
                 aria-hidden="true">
                <div class="modal-dialog">
                    <div class="modal-content">
                        <div class="modal-header">
                            <h5 class="modal-title" id="resultModalLabel">결과</h5>
                        </div>
                        <div class="modal-body">
                            가입하신 아이디는 <b>${userId}</b>입니다.
                        </div>
                        <div class="modal-footer">
                            <a href="/user/find-id" class="btn btn-secondary">돌아가기</a>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</main>

<!-- 푸터부 -->
<footer>
    <%@include file="/WEB-INF/views/common/footer.jsp" %>
</footer>

<script type="text/javascript">

</script>

</body>
</html>
