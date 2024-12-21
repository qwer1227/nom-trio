<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@include file="/WEB-INF/views/common/tags.jsp" %>
<!doctype html>
<html lang="ko">
<head>
    <%@include file="/WEB-INF/views/common/common.jsp" %>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
    <style>
        .crew-container {
            border: 1px solid #ddd;
            border-radius: 10px;
            padding: 20px;
            margin-top: 20px;
            background-color: #f9f9f9;
        }
        .crew-image {
            width: 100%;
            max-width: 150px; /* 이미지 최대 크기 설정 */
            height: 150px; /* 고정된 높이로 썸네일 크기 설정 */
            object-fit: cover; /* 이미지를 잘라서 div에 맞게 채우기 */
            border-radius: 30px;
            margin: 0 auto;
        }
        .crew-title {
            background-color: #dcdcdc;
            padding: 10px;
            margin-bottom: 20px;
            font-weight: bold;
        }
        /* 양도 버튼 */
        .btn-transfer {
            background-color: #007bff;
            color: white;
            border: none;
            padding: 10px 20px;
            cursor: pointer;
            font-size: 16px;
        }

        /* 탈퇴 버튼 */
        .btn-leave {
            background-color: #dc3545;
            color: white;
            border: none;
            padding: 10px 20px;
            cursor: pointer;
            font-size: 16px;
        }

        .action-btn {
            border-radius: 5px;
            font-weight: bold;
        }
        .modal {
            position: fixed;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            background: rgba(0, 0, 0, 0.5);
            display: none;
            justify-content: center;
            align-items: center;
        }

        .modal-content {
            background: white;
            padding: 20px;
            border-radius: 5px;
            text-align: center;
            width: 300px;
        }

        .close {
            position: absolute;
            top: 10px;
            right: 10px;
            font-size: 30px;
            cursor: pointer;
        }

    </style>
</head>
<body>
<%@include file="/WEB-INF/views/common/nav.jsp" %>

<div class="container" id="wrap">
    <div class="text-center crew-title">
        참여크루
    </div>

    <c:forEach var="c" items="${crews}">
    <div class="crew-container row align-items-center">
        <!-- 고유한 data-crew-no 속성 사용 -->

        <!-- 왼쪽 이미지 -->
        <c:choose>
            <c:when test="${empty c.thumbnail.saveName}">
                <img src="https://2404-bucket-team-1.s3.ap-northeast-2.amazonaws.com/resources/crew/images/inviting_default_main.jpg" alt="크루 대표 이미지"
                     class="crew-image" style="filter: ${crew.entered eq 'Y' ? 'grayscale(0%)' : 'grayscale(100%)'}">
            </c:when>
            <c:otherwise>
                <div class="col-md-3 text-center">
                    <img src="https://2404-bucket-team-1.s3.ap-northeast-2.amazonaws.com/resources/crew/images/${c.thumbnail.saveName}" alt="크루 이미지" class="crew-image">
                </div>
            </c:otherwise>
        </c:choose>
        <!-- 오른쪽 정보 -->
        <div class="col-md-9">
            <div class="d-flex justify-content-between mb-3">
                <h5 class="fw-bold">${c.name}</h5>
                <span>${c.memberCnt}</span>
            </div>
            <div class="d-flex justify-content-between align-items-center">
                <p class="mb-0">${c.description}</p>
                <!-- 삭제 버튼 추가 -->
                <c:choose>
                    <c:when test="${c.reader == 'Y'}">
                        <!-- 리더 양도 버튼 -->
                        <button id="transferBtn" class="action-btn btn-transfer" data-crew-no="${c.no}">리더 위임</button>
                    </c:when>
                    <c:otherwise>
                        <!-- 크루 탈퇴 버튼 -->
                        <button id="leaveBtn" class="action-btn btn-leave" data-crew-no="${c.no}">크루 탈퇴</button>
                    </c:otherwise>
                </c:choose>
            </div>
        </div>
    </div>
    </c:forEach>

    <!-- 양도 모달 (초기에는 숨김) -->
    <div class="modal" id="transferModal" tabindex="-1" aria-labelledby="transferModalLabel" aria-hidden="true">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title" id="transferModalLabel">양도할 유저 선택</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <div class="modal-body">
                    <select id="userSelect" class="form-select">
                        <!-- 유저 리스트는 JavaScript로 동적으로 추가됩니다 -->
                    </select>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">취소</button>
                    <button type="button" id="transfer" class="btn btn-primary">위임</button>
                </div>
            </div>
        </div>
    </div>



</div>

<%@include file="/WEB-INF/views/common/footer.jsp" %>
<script>
    $(document).ready(function() {
        // 양도 버튼 클릭 시 모달 열기

        $(document).on('click', '#transferBtn', function () {
            const crewNo = $(this).data('crew-no');
            $('#transfer').data('crew-no', crewNo);

            // AJAX로 크루 멤버 목록을 가져와서 모달에 유저 목록을 동적으로 추가
            $.ajax({
                url: '/mypage/getCrewMembers/' + crewNo,  // 크루 멤버 정보를 가져오는 서버 URL
                type: 'GET',
                success: function (response) {
                    // 모달의 select box 초기화
                    $('#userSelect').empty();  // 기존 항목 제거

                    // response.members가 배열인지 확인
                    if (response && Array.isArray(response)) {
                        // 유저 목록을 select box에 추가
                        $.each(response, function(index, crew) {
                            // crew.user가 존재하는지 확인하고
                            var user = crew.user;
                            if (user && user.nickname && crew.reader !== 'Y') {  // 리더가 아닌 사용자만 추가
                                $('#userSelect').append(
                                    $('<option>').val(user.no).text(user.nickname)  // user.no를 value로, user.nickname을 text로 추가
                                );
                            }
                        });
                    } else {
                        console.error("response는 배열이 아니거나 데이터가 없음");
                    }

                    // 모달을 표시
                    $('#transferModal').modal('show');
                },
                error: function () {
                    alert("유저 목록을 가져오는 데 실패했습니다.");
                }
            });
        });

        // 양도 실행
        $(document).on('click', '#transfer', function () {
                const crewNo = $(this).data('crew-no');
                const selectedUserId = $('#userSelect').val();  // 선택된 유저의 ID
                if (!selectedUserId) {
                    alert("위임할 유저를 선택해주세요.");
                    return;
                }

                const dataToSend = {
                    userNo: selectedUserId,
                    crewNo: crewNo
                };

                $.ajax({
                    url: '/mypage/transferLeader',  // 리더를 양도하는 서버 URL
                    type: 'PUT',
                    data: JSON.stringify(dataToSend),
                    dataType: 'json',
                    contentType: 'application/json',  // 요청 본문에 JSON을 전송
                    success: function (response) {
                        if (response.success) {
                            alert("리더 권한이 양도되었습니다.");
                            $('#transferModal').modal('hide'); // 모달 닫기
                            location.reload();
                        } else {
                            alert("양도에 실패했습니다.");
                        }
                    },
                    error: function () {
                        alert("리더 양도 중 오류가 발생했습니다.");
                    }
                });
            });

        // 탈퇴 실행
        $(document).on('click', '#leaveBtn', function () {
            const crewNo = $(this).data('crew-no');

            const dataToSend = {
                crewNo: crewNo
            };

            $.ajax({
                url: '/mypage/leaveCrew',  // 탈퇴를 처리하는 서버 URL
                type: 'PUT',
                data: JSON.stringify(dataToSend),
                dataType: 'json',
                contentType: 'application/json',  // 요청 본문에 JSON을 전송
                success: function(response) {
                    if (response.success) {
                        alert("탈퇴가 완료되었습니다.");
                        window.location.reload();  // 페이지 새로고침 (탈퇴 후 반영)
                    } else {
                        alert("탈퇴에 실패했습니다.");
                    }
                },
                error: function() {
                    alert("탈퇴 중 오류가 발생했습니다.");
                }
            });
        });

        // 버튼 클릭 이벤트 바인딩
        $('#transferBtn').click(openTransferModal);
        $('#leaveBtn').click(leaveCrew);
        $('#transferModal .btn-primary').click(transferLeader);
    });
</script>
</body>
</html>
