<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ include file="/WEB-INF/views/common/tags.jsp" %>
<!doctype html>
<html lang="ko">
<head>
    <style>
        a:link {
            color: black;
            text-decoration: none;
        }

        a:active {
            color: black;
            text-decoration: none;
        }

        .login-form {
            max-width: 400px;
            margin: auto;
        }
    </style>
    <%@ include file="/WEB-INF/views/common/common.jsp" %>
    <title>회원가입 폼</title>
</head>
<body>
<!-- 헤더부 -->
<header>
    <c:set var="menu" value="home"/>
    <%@ include file="/WEB-INF/views/common/nav.jsp" %>
</header>

<!-- http://localhost:80/user/login -->

<!-- 메인 컨텐츠부 -->
<main class="container">
    <div class="login-form text-center mt-5 mb-3">
        <!-- 회원가입 제목 -->
        <div class="border p-2 bg-dark text-white fw-bold mb-3">회원가입</div>

        <!-- 회원가입 폼 -->
        <form:form id="joinForm" method="POST" action="/join" modelAttribute="joinForm"
                   novalidate="novalidate">

            <!-- 아이디 -->
            <div class="form-group mb-3">
                <div class="has-validation">
                    <!-- 아이디 입력 필드 -->
                    <form:input type="text" class="form-control" placeholder="아이디*" path="id" required="required"
                                id="user-id" onblur="checkId()"/>

                    <!-- 유효성 검사 피드백 -->
                        <%-- <div class="invalid-feedback">아이디는 영소문자와 숫자만 포함하고 4~16자 사이여야 합니다.</div>
                         <div class="valid-feedback">사용 가능한 아이디입니다.</div>
     --%>
                    <!-- 중복 검사 결과 메시지 -->
                    <div id="id-check-result" class="small mt-1"></div>
                </div>
                <!-- Spring Form Errors -->
                <form:errors path="id" cssClass="text-danger fst-italic"/>
            </div>


            <!-- 비밀번호 -->
            <div class="form-group mb-3">
                <div class="input-group">
                    <form:password class="form-control" placeholder="비밀번호*" path="password" required="required"
                                   id="user-password" onblur="checkPassword()"/>
                    <button type="button" class="btn btn-outline-dark" id="togglePassword">
                        <i class="bi bi-eye"></i>
                    </button>
                </div>
                <div class="invalid-feedback">비밀번호는 10~16자, 문자, 숫자, 특수문자 조합이어야 합니다.</div>
                <div class="valid-feedback">비밀번호가 유효합니다.</div>
                <form:errors path="password" cssClass="text-danger fst-italic"/>
            </div>

            <!-- 비밀번호 확인 -->
            <div class="form-group mb-3">
                <form:password class="form-control" placeholder="비밀번호 확인*" path="passwordConfirm" required="required"
                               id="password-confirm" onblur="checkPasswordConfirm()"/>
                <div class="invalid-feedback">비밀번호가 일치하지 않습니다.</div>
                <div class="valid-feedback">비밀번호가 일치합니다!</div>
                <form:errors path="passwordConfirm" cssClass="text-danger fst-italic"/>
            </div>

            <!-- 닉네임 입력 필드 -->
            <div class="form-group mb-3">
                <div class="has-validation">
                    <form:input type="text" class="form-control" placeholder="닉네임*"
                                path="nickname" required="required"
                                id="user-nickname" onblur="checkNickname()"/>

                    <!-- 유효성 검사 피드백 -->
                        <%--<div class="invalid-feedback" id="nickname-invalid-feedback">닉네임을 입력해주세요.</div>
                        <div class="valid-feedback" id="nickname-valid-feedback">사용 가능한 닉네임입니다.</div>
    --%>
                    <!-- 중복 검사 결과 메시지 -->
                    <div id="nickname-check-result" class="small mt-1"></div>
                </div>
                <!-- 서버 측 오류 메시지를 제거하거나 조건에 맞게 표시 -->
                <form:errors path="nickname" cssClass="text-danger fst-italic"/>
            </div>


            <!-- 이름 -->
            <div class="form-group mb-3">
                <form:input class="form-control" placeholder="이름" path="name"/>
            </div>

            <!-- 이메일 -->
            <div class="form-group mb-3">
                <div class="has-validation">
                    <form:input type="email" class="form-control" placeholder="이메일*" path="email" required="required"
                                id="user-email" onblur="checkEmail()"/>

                    <!-- 유효성 검사 피드백 -->
                        <%--<div class="invalid-feedback">올바른 이메일 형식이 아닙니다.</div>
                        <div class="valid-feedback">사용 가능한 이메일입니다.</div>
    --%>
                    <!-- 중복 검사 결과 메시지 -->
                    <div id="email-check-result" class="small mt-1"></div>
                </div>
                <form:errors path="email" cssClass="text-danger fst-italic"/>
            </div>


            <!-- 휴대전화 -->
            <div class="form-group d-flex align-items-center mb-3">
                <!-- 전화번호 입력 필드 -->
                <input type="text" class="form-control me-2" id="tel" name="tel" maxlength="13" placeholder="전화번호"
                       required="required" onblur="formatPhoneNumber(event)"/>
                <!-- 본인인증 버튼
                <input type="button" onclick="smsCheck()" class="btn btn-outline-dark" value="본인인증">-->
            </div>
            <!--<ul class="txtInfo gBlank5 mt-1" id="sendVerifyCode" style="display: none;">
                <li>인증번호가 발송되었습니다.</li>
                <li>인증번호를 받지 못하셨다면 휴대폰 번호를 확인해 주세요.</li>
            </ul>-->

            <!--주소-->
            <div class="form-group d-flex align-items-center mb-3">
                <input type="text" name="postcode" class="form-control me-2" id="postcode" placeholder="우편번호*"
                       required readonly>
                <input type="button" onclick="openPostcode()" class="btn btn-dark" value="우편번호 검색">
            </div>
            <input type="text" name="address" id="address" class="form-control mb-3" placeholder="기본주소"/>
            <input type="text" name="addressDetail" id="address-detail" class="form-control mb-3"
                   placeholder="나머지 주소(선택입력 가능)" value=""/>
            <input type="text" name="address-extra" id="address-extra" class="form-control mb-3"
                   placeholder="참고항목"/>


            <!-- 이용약관 동의 -->
            <div class="form-group text-start mb-3">
                <input type="checkbox" id="terms" name="terms" class="form-check-input" data-bs-toggle="collapse"
                       data-bs-target="#termsContent" aria-expanded="false" aria-controls="termsContent"
                       required="required"/>
                <label for="terms" class="form-check-label">
                    이용약관에 동의합니다.
                </label>
                <div class="collapse mt-2" id="termsContent">
                    <div class="card card-body" style="max-height: 200px; overflow-y: auto;">
                        <!-- 여기에 약관 내용을 작성 -->
                        <p>
                            <strong>제1조 (목적)</strong><br>
                            이 약관은 회사(이하 "회사")가 제공하는 서비스의 이용 조건 및 절차, 회사와 이용자의 권리, 의무 및 책임사항을 규정함을 목적으로 합니다.
                        </p>

                        <p>
                            <strong>제2조 (정의)</strong><br>
                            1. "서비스"란 회사가 제공하는 모든 웹사이트 및 모바일 애플리케이션에서 제공되는 서비스를 의미합니다.<br>
                            2. "이용자"란 회사의 서비스를 이용하는 모든 고객을 의미합니다.
                        </p>

                        <p>
                            <strong>제3조 (서비스 이용)</strong><br>
                            1. 이용자는 본 약관에 따라 서비스를 이용할 수 있습니다.<br>
                            2. 회사는 서비스 이용과 관련하여 필요하다고 판단되는 경우 공지사항 또는 전자우편을 통해 공지합니다.
                        </p>

                        <p>
                            <strong>제4조 (책임 제한)</strong><br>
                            회사는 천재지변, 시스템 오류, 이용자의 고의 또는 과실로 인해 발생하는 손해에 대해 책임을 지지 않습니다.
                        </p>
                    </div>
                </div>
                <form:errors path="terms" cssClass="text-danger fst-italic"/>
            </div>

            <!-- 개인정보 수집 및 이용 동의 -->
            <div class="form-group text-start mb-3">
                <input type="checkbox" id="privacy" name="privacy" class="form-check-input" data-bs-toggle="collapse"
                       data-bs-target="#privacyContent" aria-expanded="false" aria-controls="privacyContent"
                       required="required"/>
                <label for="privacy" class="form-check-label">
                    개인정보 수집 및 이용에 동의합니다.
                </label>
                <div class="collapse mt-2" id="privacyContent">
                    <div class="card card-body" style="max-height: 200px; overflow-y: auto;">
                        <!-- 여기에 개인정보 수집 및 이용 내용 작성 -->
                        <p>
                            <strong>제1조 (수집하는 개인정보의 항목)</strong><br>
                            회사는 서비스 제공을 위해 다음과 같은 개인정보를 수집합니다.<br>
                            1. 필수 항목: 이름, 이메일, 전화번호<br>
                            2. 선택 항목: 생년월일, 주소
                        </p>

                        <p>
                            <strong>제2조 (개인정보의 수집 및 이용 목적)</strong><br>
                            회사는 다음의 목적을 위해 개인정보를 이용합니다.<br>
                            1. 회원 가입 및 관리<br>
                            2. 서비스 제공 및 요금 결제<br>
                            3. 고객 상담 및 민원 처리
                        </p>

                        <p>
                            <strong>제3조 (개인정보의 보유 및 이용 기간)</strong><br>
                            회사는 원칙적으로 개인정보의 수집 및 이용 목적이 달성된 후에는 해당 정보를 지체 없이 파기합니다. 단, 관련 법령에 따라 일정 기간 보관이 필요한 경우에는 해당
                            기간 동안 보관합니다.<br>
                            1. 계약 또는 청약철회 등에 관한 기록: 5년 (전자상거래 등에서의 소비자 보호에 관한 법률)<br>
                            2. 대금결제 및 재화 등의 공급에 관한 기록: 5년 (전자상거래 등에서의 소비자 보호에 관한 법률)
                        </p>

                        <p>
                            <strong>제4조 (개인정보의 제3자 제공)</strong><br>
                            회사는 이용자의 동의 없이 개인정보를 제3자에게 제공하지 않습니다. 단, 다음의 경우에는 예외로 합니다.<br>
                            1. 법령에 의한 요구가 있는 경우<br>
                            2. 서비스 제공을 위해 필요한 범위 내에서 최소한의 정보만 제공하는 경우
                        </p>

                    </div>
                </div>
                <form:errors path="privacy" cssClass="text-danger fst-italic"/>
            </div>


            <!-- 가입하기 버튼 -->
            <button type="submit" class="btn btn-dark w-100">가입하기</button>

        </form:form>
    </div>
</main>

<!-- 푸터부 -->
<footer>
    <%@ include file="/WEB-INF/views/common/footer.jsp" %>
</footer>

<script>
    // 상태 플래그
    let isIdValid = false;
    let isPasswordValid = false;
    let isPasswordConfirmed = false;
    let isTelVerified = false;
    let isEmailValid = false;
    let isEmailChecked = false;
    let isNicknameValid = false;
    let isNicknameChecked = false;

    // 아이디 유효성 검사 + 중복 검사 함수
    function checkId() {
        const idInput = document.querySelector("#user-id");
        const idFeedback = document.querySelector("#id-check-result");
        const id = idInput.value;

        // 초기화
        idFeedback.textContent = "";
        idInput.classList.remove("is-valid", "is-invalid");
        idFeedback.classList.remove("valid-feedback", "invalid-feedback")
        // 유효성 검사: 영소문자 + 숫자만 허용, 길이는 4~16자
        if (!/^[a-z0-9]{4,16}$/.test(id)) {
            idInput.classList.add("is-invalid");
            idFeedback.classList.add("invalid-feedback")
            idFeedback.textContent = "아이디는 영소문자와 숫자만 포함하고 4~16자 사이여야 합니다.";
            return;
        }

        // 중복 확인 요청
        fetch(`/api/users/check-id?id=\${id}`)
            .then(response => {
                if (!response.ok) throw new Error("서버 오류 발생");
                return response.json(); // 서버가 JSON 형태로 반환한다고 가정
            })
            .then(data => {
                if (data.duplicate) { // 중복된 경우
                    idInput.classList.add("is-invalid");
                    idFeedback.classList.add("invalid-feedback")
                    idFeedback.textContent = "이미 사용 중인 아이디입니다.";
                } else { // 사용 가능한 경우
                    idInput.classList.add("is-valid");
                    idFeedback.classList.add("valid-feedback")
                    idFeedback.textContent = "사용 가능한 아이디입니다.";
                }
            })
            .catch(error => {
                console.error("Error:", error);
                idInput.classList.add("is-invalid");
                idFeedback.classList.add("invalid-feedback")
                idFeedback.textContent = "서버 오류가 발생했습니다.";
            });
    }

    // 비밀번호 유효성 검사
    function checkPassword() {
        let passwordInput = document.querySelector("#user-password");
        let password = passwordInput.value;

        // 비밀번호 길이와 복잡성 체크
        if (!/^(?=.*[a-zA-Z])(?=.*[0-9])(?=.*[^a-zA-Z0-9]).{10,16}$/.test(password)) {
            // 비밀번호는 10~16자, 문자, 숫자, 특수문자 조합
            passwordInput.classList.add("is-invalid");
            passwordInput.classList.remove("is-valid");
            isPasswordValid = false;
        } else {
            passwordInput.classList.add("is-valid");
            passwordInput.classList.remove("is-invalid");
            isPasswordValid = true;
        }
    }

    document.getElementById("togglePassword").addEventListener("click", function () {
        const passwordField = document.getElementById("user-password");
        const type = passwordField.getAttribute("type") === "password" ? "text" : "password";
        passwordField.setAttribute("type", type);

        // 아이콘 변경
        const icon = this.querySelector("i");
        icon.classList.toggle("bi-eye");
        icon.classList.toggle("bi-eye-slash");
    });

    // 비밀번호 확인 유효성 검사
    function checkPasswordConfirm() {
        let password = document.querySelector("#user-password").value;
        let passwordConfirmInput = document.querySelector("#password-confirm");
        let passwordConfirm = passwordConfirmInput.value;

        if (password !== passwordConfirm) {
            passwordConfirmInput.classList.add("is-invalid");
            passwordConfirmInput.classList.remove("is-valid");
            isPasswordConfirmed = false;
        } else {
            passwordConfirmInput.classList.add("is-valid");
            passwordConfirmInput.classList.remove("is-invalid");
            isPasswordConfirmed = true;
        }
    }

    function formatPhoneNumber(event) {
        // 입력된 전화번호 값
        let phoneNumber = event.target.value;

        // 숫자만 남기고 다른 문자는 모두 제거
        phoneNumber = phoneNumber.replace(/[^0-9]/g, "");

        // 전화번호가 11자리이면 010-1111-1111 형식으로 변환
        if (phoneNumber.length === 11) {
            phoneNumber = phoneNumber.slice(0, 3) + '-' + phoneNumber.slice(3, 7) + '-' + phoneNumber.slice(7, 11);
        }

        // 형식이 맞춰진 전화번호를 입력 필드에 다시 설정
        event.target.value = phoneNumber;
    }

    // 이메일 유효성 검사 + 중복 검사 함수
    function checkEmail() {
        const emailInput = document.querySelector("#user-email");
        const emailFeedback = document.querySelector("#email-check-result");
        const email = emailInput.value;

        // 초기화
        emailFeedback.textContent = "";
        emailInput.classList.remove("is-valid", "is-invalid");
        emailFeedback.classList.remove("valid-feedback", "invalid-feedback")

        // 유효성 검사: 이메일 형식 확인
        const emailPattern = /^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$/;
        if (!emailPattern.test(email)) {
            emailInput.classList.add("is-invalid");
            emailFeedback.classList.add("invalid-feedback")
            emailFeedback.textContent = "올바른 이메일 형식이 아닙니다.";
            return;
        }

        // 중복 확인 요청
        fetch(`/api/users/check-email?email=\${email}`)
            .then(response => {
                if (!response.ok) throw new Error("서버 오류 발생");
                return response.json(); // JSON 형태로 응답한다고 가정
            })
            .then(data => {
                if (data.duplicate) { // 중복된 경우
                    emailInput.classList.add("is-invalid");
                    emailFeedback.classList.add("invalid-feedback")
                    emailFeedback.textContent = "이미 사용 중인 이메일입니다.";
                } else { // 사용 가능한 경우
                    emailInput.classList.add("is-valid");
                    emailFeedback.classList.add("valid-feedback")
                    emailFeedback.textContent = "사용 가능한 이메일입니다.";
                }
            })
            .catch(error => {
                console.error("Error:", error);
                emailInput.classList.add("is-invalid");
                emailFeedback.classList.add("invalid-feedback")
                emailFeedback.textContent = "서버 오류가 발생했습니다.";
            });

    }

    // 닉네임 유효성 검사 + 중복 검사 함수
    function checkNickname() {
        const nicknameInput = document.querySelector("#user-nickname");
        const nicknameFeedback = document.querySelector("#nickname-check-result");
        const nickname = nicknameInput.value;

        // 초기화
        nicknameFeedback.textContent = "";
        nicknameInput.classList.remove("is-valid", "is-invalid");
        nicknameFeedback.classList.remove("valid-feedback", "invalid-feedback")

        // 유효성 검사: 닉네임 형식 확인
        const nicknamePattern = /^[가-힣a-z0-9]{2,}$/;
        if (!nicknamePattern.test(nickname)) {
            nicknameInput.classList.add("is-invalid");
            nicknameFeedback.classList.add("invalid-feedback")
            nicknameInvalidFeedback.textContent = "닉네임은 한글, 영문 소문자, 숫자만 포함하며 2글자 이상이어야 합니다.";
            return; // 유효성 검사 실패 시 더 이상 진행하지 않음
        }

        // 중복 확인 요청
        fetch(`/api/users/check-nickname?nickname=\${nickname}`)
            .then(response => {
                if (!response.ok) throw new Error("서버 오류 발생");
                return response.json(); // JSON 형태로 응답한다고 가정
            })
            .then(data => {
                if (data.duplicate) { // 중복된 경우
                    nicknameInput.classList.add("is-invalid");
                    nicknameFeedback.classList.add("invalid-feedback")
                    nicknameFeedback.textContent = "이미 사용 중인 닉네임입니다.";
                } else { // 사용 가능한 경우
                    nicknameInput.classList.add("is-valid");
                    nicknameFeedback.classList.add("valid-feedback")
                    nicknameFeedback.textContent = "사용 가능한 닉네임입니다.";
                }
            })
            .catch(error => {
                console.error("Error:", error);
                nicknameInput.classList.add("is-invalid");
                nicknameFeedback.classList.add("invalid-feedback")
                nicknameFeedback.textContent = "서버 오류가 발생했습니다.";
                });
    }


    // 카카오 주소 api
    function openPostcode() {
        new daum.Postcode({
            oncomplete: function (data) {
                // 팝업에서 검색결과 항목을 클릭했을때 실행할 코드를 작성하는 부분.

                // 각 주소의 노출 규칙에 따라 주소를 조합한다.
                // 내려오는 변수가 값이 없는 경우엔 공백('')값을 가지므로, 이를 참고하여 분기 한다.
                var addr = ''; // 주소 변수
                var extraAddr = ''; // 참고항목 변수

                //사용자가 선택한 주소 타입에 따라 해당 주소 값을 가져온다.
                if (data.userSelectedType === 'R') { // 사용자가 도로명 주소를 선택했을 경우
                    addr = data.roadAddress;
                } else { // 사용자가 지번 주소를 선택했을 경우(J)
                    addr = data.jibunAddress;
                }

                // 사용자가 선택한 주소가 도로명 타입일때 참고항목을 조합한다.
                if (data.userSelectedType === 'R') {
                    // 법정동명이 있을 경우 추가한다. (법정리는 제외)
                    // 법정동의 경우 마지막 문자가 "동/로/가"로 끝난다.
                    if (data.bname !== '' && /[동|로|가]$/g.test(data.bname)) {
                        extraAddr += data.bname;
                    }
                    // 건물명이 있고, 공동주택일 경우 추가한다.
                    if (data.buildingName !== '' && data.apartment === 'Y') {
                        extraAddr += (extraAddr !== '' ? ', ' + data.buildingName : data.buildingName);
                    }
                    // 표시할 참고항목이 있을 경우, 괄호까지 추가한 최종 문자열을 만든다.
                    if (extraAddr !== '') {
                        extraAddr = ' (' + extraAddr + ')';
                    }
                    // 조합된 참고항목을 해당 필드에 넣는다.
                    document.getElementById("address-extra").value = extraAddr;

                } else {
                    document.getElementById("address-extra").value = '';
                }

                // 우편번호와 주소 정보를 해당 필드에 넣는다.
                document.getElementById('postcode').value = data.zonecode;
                document.getElementById("address").value = addr;
                // 커서를 상세주소 필드로 이동한다.
                document.getElementById("address-detail").focus();
            }
        }).open();
    }

    $(document).ready(function () {
        //
        $("#memo-box-direct").hide();

        // 변경 이벤트 처리
        $("#memo-box").change(function () {
            if ($(this).val() === "direct") {
                $("#memo-box-direct").show();
            } else {
                $("#memo-box-direct").hide().val("");
            }
        });
    });

    function validateForm() {
        if (isIdValid && isPasswordValid && isPasswordConfirmed && isTelVerified && isEmailValid && isEmailChecked && isNicknameValid && isNicknameChecked) {
            // 모든 조건이 만족하면 폼을 제출
            document.getElementById("form").submit();
        } else {
            alert("모든 필드를 올바르게 입력해주세요.");
        }
    }


</script>
</body>
</html>
