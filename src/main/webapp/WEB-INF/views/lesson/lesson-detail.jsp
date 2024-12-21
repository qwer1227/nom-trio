<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@include file="/WEB-INF/views/common/tags.jsp" %>
<!doctype html>
<html lang="ko">
<head>
    <%@include file="/WEB-INF/views/common/common.jsp" %>
</head>
<body>
<%@include file="/WEB-INF/views/common/nav.jsp" %>
<div class="container-xxl" id="wrap">
    <div class="row mb-5">
        <div class="col-2"></div>
        <div class="col">
            <h1 class="text-center mb-5 bg-black text-white">${lesson.title}</h1>
            <a href="/lesson" class="btn btn-dark" style="text-decoration: none"><strong>일정보기</strong></a>
        </div>
        <div class="col-2"></div>
    </div>
    <div class="row mb-3 d-flex justify-content-center">
        <div class="col-4">
            <c:if test="${not empty images['THUMBNAIL']}">
                <img src="${s3}/resources/images/lesson/${images['THUMBNAIL']}"
                     alt="Thumbnail" id="Thumbnail" style="width: 100%; height: 300px;"/>
            </c:if>
        </div>
        <div class="col-4">
            <table class="table">
                <colgroup>
                    <col width="20%">
                    <col width="*%">
                </colgroup>
                <tr>
                    <th>레슨명</th>
                    <td>${lesson.title}</td>
                </tr>
                <tr>
                    <th>모집상태</th>
                    <td>
                        <span class="badge ${lesson.status == '모집중' ? 'bg-success'  :
                        lesson.status == '완료' ? 'bg-secondary' :
                         lesson.status == '취소' ? 'bg-danger' :
                         lesson.status == '마감' ? 'bg-secondary' : '' }">${lesson.status}</span>
                    </td>
                </tr>
                <tr>
                    <th>과목</th>
                    <td>${lesson.subject}</td>
                </tr>
                <tr>
                    <th>강사명</th>
                    <td>${lesson.lecturer.name}</td>
                </tr>
                <tr>
                    <th>장소</th>
                    <td>${lesson.place}</td>
                </tr>
                <tr>
                    <th>레슨날짜</th>
                    <td>${startDate} ${startTime} ~ ${endTime}</td>
                </tr>
                <tr>
                    <th>참여인원</th>
                    <td>${lesson.participant}/5</td>
                </tr>
                <tr>
                    <th>결제금액</th>
                    <td><fmt:formatNumber value="${lesson.price}" pattern="#,###"/>원</td>
                </tr>
            </table>
        </div>
    </div>
    <div class="row text-end mb-3">
        <div class="col-2"></div>
        <div class="col border-bottom border-dark border-2 pb-3">
            <c:set var="now" value="<%= new java.util.Date() %>"/>
            <fmt:formatDate value="${now}" pattern="yyyy-MM-dd" var="formattedNow"/>
            <form name="lessonDto" method="get" action="/pay/form" id="hidden-form">
                <input type="hidden" name="lessonNo" value="${lesson.lessonNo}">
                <input type="hidden" name="title" value="${lesson.title}">
                <input type="hidden" name="price" value="${lesson.price}">
                <input type="hidden" name="lecturerName" value="${lesson.lecturer.name}">
                <input type="hidden" name="startDate" value="${startDate}">
                <input type="hidden" name="startTime" value="${startTime}">
                <input type="hidden" name="subject" value="${lesson.subject}">
                <input type="hidden" name="place" value="${lesson.place}">
                <input type="hidden" name="participant" value="${lesson.participant}">
                <c:if test='${lesson.status ne "마감" or "완료" or "취소"}'>
                    <security:authorize access="isAuthenticated()">
                        <security:authentication property="principal" var="loginUser"/>
                        <input type="hidden" name="userId" value="${loginUser.id}">
                        <!-- 수강신청 버튼을 JavaScript로 제어 -->
                        <button type="submit" class="btn btn-primary" id="reservation-btn">수강신청</button>
                    </security:authorize>
                    <c:if test="${empty loginUser}">
                        <button type="button" id="non-login" class="btn btn-primary">수강신청</button>
                    </c:if>
                </c:if>
            </form>
        </div>
        <div class="col-2"></div>
    </div>
    <div class="row">
        <div class="col-2"></div>
        <div class="col text-center"><h1>강의 계획 및 커리큘럼</h1></div>
        <div class="col-2"></div>
    </div>
    <div class="row">
        <div class="col-2"></div>
        <div class="col text-center border-bottom border-dark border-2 pb-3 mb-3 ">
            <p>
                ${lesson.plan}
            </p>
            <p>
                <c:if test="${not empty images.MAIN_IMAGE}">
                    <img src="${s3}/resources/images/lesson/${images['MAIN_IMAGE']}"
                         alt="Main Image"/>
                </c:if>
            </p>
        </div>
        <div class="col-2"></div>
    </div>

</div>
<%@include file="/WEB-INF/views/common/footer.jsp" %>
<script>
    document.getElementById("non-login").addEventListener("click", function () {
        // 사용자에게 로그인 요청 메시지 표시
        var confirmResult = confirm("로그인이 필요합니다. 로그인 페이지로 이동하시겠습니까?");

        // 사용자가 '확인'을 클릭하면 /login 페이지로 이동
        if (confirmResult) {
            window.location.href = "/login";  // 로그인 페이지로 리다이렉트
        }
    });
</script>
</body>
</html>