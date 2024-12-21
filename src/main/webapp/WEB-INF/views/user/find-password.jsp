<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@include file="/WEB-INF/views/common/tags.jsp" %>
<!doctype html>
<html lang="ko">
<head>
    <%@include file="/WEB-INF/views/common/common.jsp" %>
    <title>비밀번호 찾기 폼</title>
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
            <!-- 비밀번호 찾기 제목 -->
            <div class="border p-2 bg-dark text-white fw-bold mb-3">비밀번호 찾기</div>

            <!-- 비밀번호 찾기 폼 -->
            <form:form method="post" action="/find-password">
                <div class="mb-3">
                    가입 시 등록하신 아이디와 이메일을 입력하시면<br>
                    임시 비밀번호가 이메일로 발송됩니다.
                </div>
                <div class="mb-3">
                    <input type="text" class="form-control" placeholder="아이디" id="id" name="id">
                </div>
                <div class="mb-3 input-group">
                    <input type="text" class="form-control" placeholder="이메일" id="email" name="email">
                    <button type="button" id="emailCheckBtn" class="btn btn-outline-dark btn-sm" onclick="sendEmailVerification()">전송</button>
                </div>

                <!-- 인증번호 입력 섹션 -->
                <div id="verifySection" style="display: none;" class="mt-3">
                    <div class="mb-3">
                        <input type="text" class="form-control" placeholder="인증번호 입력" id="authCode">
                    </div>
                    <button type="button" class="btn btn-primary" onclick="verifyAuthCode()">인증 확인</button>
                </div>

                <div class="mt-4">
                    <button type="submit" class="btn btn-dark w-100">임시 비밀번호 발급</button>
                </div>
            </form:form>
        </div>
    </div>
</main>

<%@include file="/WEB-INF/views/common/footer.jsp" %>

<script>
    // 이메일 인증 요청
    function sendEmailVerification() {
        const emailInput = document.getElementById("email").value;

        // 이메일 입력 확인
        if (!emailInput) {
            alert("이메일을 입력해주세요.");
            return;
        }

        // Ajax를 이용해 서버에 이메일 인증 요청
        fetch("/emailCheck", {
            method: "POST",
            headers: {
                "Content-Type": "application/json"
            },
            body: JSON.stringify({ email: emailInput })
        })
            .then(response => response.text()) // 서버에서 반환된 인증번호
            .then(authCode => {
                alert("인증번호가 전송되었습니다.");
                sessionStorage.setItem("authCode", authCode); // 인증번호를 세션에 저장
                document.getElementById("verifySection").style.display = "block"; // 인증번호 입력 섹션 표시
            })
            .catch(error => {
                console.error("Error:", error);
                alert("이메일 전송 중 오류가 발생했습니다.");
            });
    }

    // 인증번호 확인
    function verifyAuthCode() {
        const enteredCode = document.getElementById("authCode").value;
        const storedCode = sessionStorage.getItem("authCode");

        if (enteredCode === storedCode) {
            alert("이메일 인증이 완료되었습니다.");
        } else {
            alert("인증번호가 일치하지 않습니다. 다시 시도해주세요.");
        }
    }
</script>

</body>
</html>