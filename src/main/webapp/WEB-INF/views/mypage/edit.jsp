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
        .valid-feedback {
            color: green;
            font-size: 0.9em;
        }
        .invalid-feedback {
            color: red;
            font-size: 0.9em;
        }
    </style>

</head>
<body>
<%@include file="/WEB-INF/views/common/nav.jsp" %>
<div class="container-xxl text-center" id="wrap">
    <h2>내 정보 수정</h2>

    <div class="form-container">
        <form action="/mypage/edit" method="post" class="form-group" id="form-modify">
            <!-- 비밀번호 -->
            <div class="mb-3">
                <label for="password" class="form-label">비밀번호</label>
                <input type="password" id="password" name="password" class="form-control" placeholder="새 비밀번호" required>
                <div id="passwordFeedback"></div> <!-- 피드백 영역 -->
            </div>

            <!-- 재 입력 -->
            <div class="mb-3">
                <label for="confirmPassword" class="form-label">비밀번호 확인</label>
                <input type="password" id="confirmPassword" name="confirmPassword" class="form-control" placeholder="새 비밀번호 확인" required>
                <div id="confirmPasswordFeedback"></div> <!-- 피드백 영역 -->
            </div>

            <!-- 닉네임 -->
            <div class="mb-3">
                <label for="nickname" class="form-label">닉네임</label>
                <div class="d-flex">
                    <input type="text" id="nickname" name="nickname" class="form-control me-2" value="${user.nickname}" required>
                    <!-- 중복 확인 버튼 -->
                    <button type="button" id="checkNickname" class="btn btn-outline-primary flex-shrink-0" style="min-width: 100px;">중복 확인</button>
                </div>
                <div id="nicknameFeedback"></div> <!-- 피드백 영역 -->
            </div>

            <!-- 전화번호 -->
            <div class="mb-3">
                <label for="phone" class="form-label">전화번호</label>
                <input type="text" id="phone" name="phone" class="form-control" value="${user.phone}" required>
                <div id="phoneFeedback"></div> <!-- 피드백 영역 -->
            </div>

            <!-- 이메일 -->
            <div class="mb-3">
                <label for="email" class="form-label">이메일</label>
                <input type="email" id="email" name="email" class="form-control" value="${user.email}" required>
                <div id="emailFeedback"></div> <!-- 피드백 영역 -->
            </div>

            <!-- 주소 선택 셀렉트 박스 -->
            <div class="mb-3 d-flex align-items-center">
                <label for="addressSelect" class="form-label me-2">주소 선택</label>
                <select id="addressSelect" class="form-select me-2 flex-grow-1" name="addrNo" onchange="populateAddressFields()">
                    <option value="" disabled selected>주소를 선택하세요</option>
                    <c:forEach var="addr" items="${addr}">
                        <option value="${addr.no}">
                                ${addr.address} (${addr.addressDetail})
                        </option>
                    </c:forEach>
                </select>
                <button type="button" class="btn btn-secondary me-2" id="editAddressBtn" onclick="showAddressFields()">수정</button>
                <!-- 기본배송지 설정 체크박스 -->
                <div class="form-check d-flex align-items-center">
                    <input class="form-check-input" type="checkbox" id="defaultAddress" name="isAddrHome">
                    <label class="form-check-label ms-1" for="defaultAddress">기본배송지 설정</label>
                </div>
            </div>



            <!-- 숨겨진 주소 입력 폼 -->
            <div id="addressFields" style="display: none;">
                <div class="form-group d-flex align-items-center mb-3">
                    <input type="text" name="postcode" class="form-control me-2" id="postcode" placeholder="우편번호" required readonly>
                    <input type="button" onclick="openPostcode()" class="btn btn-dark" value="우편번호 검색">
                </div>
                <input type="text" name="address" id="address" class="form-control mb-3" placeholder="기본주소"/>
                <input type="text" name="addressDetail" id="address-detail" class="form-control mb-3" placeholder="나머지 주소(선택입력 가능)" value=""/>
                <input type="text" name="address-extra" id="address-extra" class="form-control mb-3" placeholder="참고항목"/>
            </div>


            <!-- 수정 버튼 -->
            <button type="submit" class="btn btn-primary">수정하기</button>
        </form>
    </div>
</div>

<%@include file="/WEB-INF/views/common/footer.jsp" %>

<script>
    function showAddressFields() {
        document.getElementById("addressFields").style.display = "block";
    }

    let fieldValidResult = {
        password: false,
        confirmPassword: false,
        nickname: false,
        phone: false,
        email: false,
        newPassword: false

    };

    // 유효성 검사 규칙
    const validators = {
        password: (value) => value.length >= 8,  // 비밀번호 길이 8자 이상
        confirmPassword: (value) => value === document.getElementById("password").value, // 비밀번호 확인 일치 여부
        nickname: (value) => /^[가-힣a-zA-Z0-9]{2,10}$/.test(value),  // 닉네임 2~10자 한글, 영문, 숫자만
        phone: (value) => /^01[0-9]{8,9}$/.test(value),  // 전화번호 형식 (010으로 시작하는 10~11자리)
        email: (value) => /^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(value),  // 이메일 형식
    };

    // 유효성 검사 피드백 출력 함수
    function validateInput(input) {
        const value = input.value.trim();
        const id = input.id;

        const isValid = validators[id](value);
        const feedbackElement = document.getElementById(id + "Feedback");

        if (isValid) {
            fieldValidResult[id] = true;
            feedbackElement.textContent = "✔ 유효한 입력입니다.";
            feedbackElement.style.color = "green";
        } else {
            fieldValidResult[id] = false;
            feedbackElement.textContent = getErrorMessage(id);
            feedbackElement.style.color = "red";
        }
        console.log(fieldValidResult)
    }

    // 오류 메시지 반환 함수
    function getErrorMessage(id) {
        switch (id) {
            case "password":
                return "비밀번호는 8자 이상이어야 합니다.";
            case "confirmPassword":
                return "비밀번호가 일치하지 않습니다.";
            case "nickname":
                return "닉네임은 2~10자의 한글, 영문, 숫자만 가능합니다.";
            case "phone":
                return "전화번호는 01012345678 형식이어야 합니다.";
            case "email":
                return "유효한 이메일 주소를 입력하세요.";
            case "newPassword":
                return "이전비밀번호와 같습니다";
            default:
                return "유효하지 않은 입력입니다.";
        }
    }

    document.getElementById("form-modify").addEventListener("submit", function (event) {
        for (const [key, value] of Object.entries(fieldValidResult)) {
            if (!value) {
                alert("입력값이 유효하지 않습니다.");
                event.preventDefault();
                return;
            }
        }


    })

    // 각 입력 필드에 keyup 이벤트 처리
    document.getElementById("password").addEventListener("keyup", function () {
        validateInput(this);
    });
    document.getElementById("confirmPassword").addEventListener("keyup", function () {
        validateInput(this);
    });
    document.getElementById("nickname").addEventListener("keyup", function () {
        validateInput(this);
    });
    document.getElementById("phone").addEventListener("keyup", function () {
        validateInput(this);
    });
    document.getElementById("email").addEventListener("keyup", function () {
        validateInput(this);
    });

    $(document).ready(function () {
        // 중복 확인 버튼 클릭 이벤트
        $('#checkNickname').click(function () {
            const nickname = $('#nickname').val().trim(); // 닉네임 값 가져오기

            if (nickname === "") {
                $('#nicknameFeedback').text('닉네임을 입력해주세요.').css('color', 'red');
                return;
            }

            $.ajax({
                url: '/mypage/edit/nickname', // REST 컨트롤러 URL
                type: 'GET', // 요청 방식
                data: { nickname: nickname }, // 쿼리 파라미터로 닉네임 전달
                success: function (response) {
                    // 서버 응답 처리
                    if (response.isAvailable) {
                        $('#nicknameFeedback').text('사용 가능한 닉네임입니다.').css('color', 'green');
                    } else {
                        $('#nicknameFeedback').text('이미 사용 중인 닉네임입니다.').css('color', 'red');
                    }
                },
                error: function (xhr, status, error) {
                    console.error('AJAX 요청 실패:', error);
                    $('#nicknameFeedback').text('중복 확인 중 오류가 발생했습니다.').css('color', 'red');
                }
            });
        });

        // 비밀번호 비교 이벤트 (비밀번호 입력 필드에서 포커스가 떠날 때)
        $('#password').on('blur', function () {
            const newPassword = $(this).val().trim();

            // 새 비밀번호가 비어있지 않을 때만 요청
            if (newPassword !== "") {
                $.ajax({
                    url: '/mypage/edit/password/check', // REST 컨트롤러 URL
                    type: 'POST', // 요청 방식
                    contentType: 'application/json', // JSON 데이터 전송
                    data: JSON.stringify({ newPassword: newPassword }), // 요청 데이터
                    success: function (response) {
                        // 서버 응답 처리
                        if (response.isSameAsOldPassword) {
                            $('#passwordFeedback').text('이전 비밀번호와 같습니다. 다른 비밀번호를 입력해주세요.').css('color', 'red');
                            fieldValidResult.newPassword = false;  // 유효하지 않으면 false로 설정
                            fieldValidResult.password = false;
                        } else {
                            $('#passwordFeedback').text('✔ 유효한 비밀번호입니다.').css('color', 'green');
                            fieldValidResult.newPassword = true;  // 유효하면 true로 설정
                        }
                    },
                    error: function (xhr, status, error) {
                        console.error('AJAX 요청 실패:', error);
                        $('#passwordFeedback').text('비밀번호 확인 중 오류가 발생했습니다.').css('color', 'red');
                        fieldValidResult.newPassword = false;  // 오류가 발생하면 false로 설정
                    }
                });
            }
        });
    });

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

</script>
</body>


</html>
