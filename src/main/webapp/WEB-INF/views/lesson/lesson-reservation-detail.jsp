<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@include file="/WEB-INF/views/common/tags.jsp" %>
<!doctype html>
<html lang="ko">
<head>
    <%@include file="/WEB-INF/views/common/common.jsp" %>
</head>
<body>
<%@include file="/WEB-INF/views/common/nav.jsp" %>
<div class="container-xxl border align-content-center" id="wrap">
    <div class="row text-center mb-5">
        <h1>예약 레슨</h1>
    </div>
    <div class="row d-flex justify-content-center mb-3">
        <div class="col-5">
            <img src="${s3}/resources/images/lesson/${images['THUMBNAIL']}"
                 alt="Thumbnail" id="Thumbnail" style="width: 100%; height: 300px;"/>
        </div>
        <div class="col-5">
            <table class="table">
                <colgroup>
                    <col width="15%">
                    <col width="*%">
                </colgroup>
                <tr>
                    <th>레슨명</th>
                    <td>
                        <a href="/lesson/detail?lessonNo=${lessonReservation.lesson.lessonNo}">${lessonReservation.lesson.title}
                    </td>
                </tr>
                <tr>
                    <th>과정</th>
                    <td>${lessonReservation.lesson.subject}</td>
                </tr>
                <tr>
                    <th>강사명</th>
                    <td>${lessonReservation.lesson.lecturer.name}</td>
                </tr>
                <tr>
                    <th>레슨날짜</th>
                    <td>
                        ${startDate} ${startTime}
                    </td>
                </tr>
                <tr>
                    <th>결제금액</th>
                    <td><fmt:formatNumber value="${lessonReservation.lesson.price}" pattern="#,###"/>원</td>
                </tr>
                <tr>
                    <th>예약상태</th>
                    <td>
                        <c:if test="${lessonReservation.status eq '수강종료'}">
                            <span class="badge bg-secondary">수강종료</span>
                        </c:if>
                        <c:if test="${lessonReservation.status eq '예약'}">
                            <span class="badge bg-success">예약</span>
                        </c:if>
                        <c:if test="${lessonReservation.status eq '취소'}">
                            <span class="badge bg-danger">취소</span>
                        </c:if>
                        <c:if test="${lessonReservation.status eq '환불'}">
                            <span class="badge bg-warning">환불</span>
                        </c:if>
                    </td>
                </tr>
            </table>
        </div>
    </div>
    <div class="row">
        <div class="col-1"></div>
        <div class="col">
            <c:if test="${not empty lessonReservation.user.id}">
                <a href="/lesson/reservation?userId=${lessonReservation.user.id}" class="btn btn-dark w-100">예약 내역</a>
            </c:if>
        </div>
        <div class="col-1"></div>
    </div>
</div>
<%@include file="/WEB-INF/views/common/footer.jsp" %>
</body>
</html>