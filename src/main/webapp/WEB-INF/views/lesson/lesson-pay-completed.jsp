<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@include file="/WEB-INF/views/common/tags.jsp" %>
<!doctype html>
<html lang="ko">
<head>
    <%@include file="/WEB-INF/views/common/common.jsp" %>
</head>
<%@include file="/WEB-INF/views/common/nav.jsp" %>
<body>
<div class="container-xxl align-content-center" id="wrap">
    <div class="row text-center mb-5">
        <h1>레슨 예약 완료</h1>
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
                        ${startDate} ${startTime} ~ ${endTime}
                    </td>
                </tr>
                <tr>
                    <th>결제금액</th>
                    <td><fmt:formatNumber value="${lessonReservation.lesson.price}" pattern="#,###"/>원</td>
                </tr>
            </table>
        </div>
    </div>
    <div class="row">
        <div class="col-1"></div>
        <div class="col">
            <a href="/lesson/reservation?userId=${lessonReservation.user.id}" class="btn btn-dark w-100">예약 내역</a>
        </div>
        <div class="col-1"></div>
    </div>
</div>
<%@include file="/WEB-INF/views/common/footer.jsp" %>
</body>
</html>