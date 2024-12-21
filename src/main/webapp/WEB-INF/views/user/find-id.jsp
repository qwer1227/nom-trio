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
            <div class="border p-2 bg-dark text-white fw-bold mb-3">아이디 찾기</div>

            <!-- 이메일로 아이디 찾기 폼 -->
            <form method="post" action="/find-id">
                <div class="mb-3">
                    <label for="email">
                        <h6>가입 시 등록하신 이메일을 입력해 주세요.</h6></label>
                    <input type="email" class="form-control" id="email"
                           name="email" placeholder="이메일" required="required"/>
                </div>
                <button type="submit" class="btn btn-dark w-100">확인</button>
            </form>

            <div class="mt-3">
                <!-- 서버에서 전달한 메시지를 Bootstrap alert로 표시 -->
                <c:if test="${not empty message}">
                    <div class="alert alert-info">${message}</div>
                </c:if>
            </div>
        </div>
    </div>

    <!-- 아이디 찾기 결과 모달 -->
    <div class="modal fade" id="idFindModal" tabindex="-1" aria-labelledby="idFindModalLabel" aria-hidden="true">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title" id="idFindModalLabel">아이디 찾기 결과</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <div class="modal-body" id="modalBody">
                    <!--결과 메시지 표시 부분-->
                    가입하신 아이디는 <b>${data.userId}</b>입니다.
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">닫기</button>
                </div>
            </div>
        </div>
    </div>

</main>


<!-- 푸터부 -->
<footer>
    <%@include file="/WEB-INF/views/common/footer.jsp" %>
</footer>

<script>
    // 아이디 마스킹 함수
    function maskUserId(userId) {
        // 아이디의 길이가 4 이상이면 앞 4자리만 남기고 나머지는 *로 마스킹
        if (userId.length > 4) {
            return userId.substring(0, 4) + '****';
        }
        return userId;  // 아이디가 4자리 이하일 경우 그대로 반환
    }

    // 폼 제출 시 처리
    document.querySelector("form").addEventListener("submit", function (event) {
        event.preventDefault();  // 폼 기본 동작을 막음

        // 이메일 값 가져오기
        const email = document.querySelector("input[name='email']").value;

        // 이메일로 아이디 찾기 요청
        fetch("/find-id", {
            method: "POST",
            headers: {
                "Content-Type": "application/x-www-form-urlencoded",
            },
            body: "email=" + email,
        })
            .then(response => {
                return response.json();
            })
            .then(data => {
                // 모달 본문에 결과 메시지 추가
                const modalBody = document.getElementById("modalBody");
                if (data.success) {
                    // 아이디 마스킹 처리
                    const maskedUserId = maskUserId(data.userId);
                    modalBody.innerHTML = `<p>가입하신 아이디는 <b>\${maskedUserId}</b>입니다.</p>`;
                } else {
                    modalBody.innerHTML = `<p>\${data.error}</p>`;
                }
                // 모달 띄우기
                var myModal = new bootstrap.Modal(document.getElementById('idFindModal'));
                myModal.show();
            })
    });
</script>

</body>
</html>
