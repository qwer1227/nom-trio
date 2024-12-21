<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@include file="/WEB-INF/views/common/tags.jsp" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<!doctype html>
<html lang="ko">
<head>
    <%@include file="/WEB-INF/views/common/common.jsp" %>
</head>
<body>
<%@include file="/WEB-INF/views/common/nav.jsp" %>
<security:authentication property="principal" var="loginUser"/>
<div class="container-xxl" id="wrap">
    <div class="row text-center mb-3">
        <div class="col">
            <h2>레슨 예약 내역</h2>
        </div>
    </div>
    <form form="condition" method="get" action="/lesson/reservation" id="searchForm">
        <div class="row mb-3">
            <div class="col-1">
                <label for="subject">과목</label>
                <select name="lessonSubject" class="form-select" id="subject" onchange="submitForm()">
                    <option value="" <c:if test="${empty condition.lessonSubject}">selected</c:if>>모두</option>
                    <option value="호흡" <c:if test="${condition.lessonSubject == '호흡'}">selected</c:if>>호흡</option>
                    <option value="자세" <c:if test="${condition.lessonSubject == '자세'}">selected</c:if>>자세</option>
                    <option value="운동" <c:if test="${condition.lessonSubject == '운동'}">selected</c:if>>운동</option>
                </select>
            </div>
            <div class="col-2">
                <label for="status">예약상태</label>
                <select name="reservationStatus" class="form-select" id="status" onchange="submitForm()">
                    <option value="" <c:if test="${empty condition.reservationStatus}">selected</c:if>>모두</option>
                    <option value="예약" <c:if test="${condition.reservationStatus == '예약'}">selected</c:if>>예약</option>
                    <option value="수강종료" <c:if test="${condition.reservationStatus == '수강종료'}">selected</c:if>>수강종료
                    </option>
                    <option value="취소" <c:if test="${condition.reservationStatus == '취소'}">selected</c:if>>취소</option>
                </select>
            </div>
            <div class="col-2">
                <label for="startDate">시작</label>
                <input type="date" id="startDate" name="start" class="form-select" value="${condition.start}"
                       onchange="submitForm()">
            </div>
            <div class="col-2">
                <label for="endDate">종료</label>
                <input type="date" id="endDate" name="end" class="form-select" value="${condition.end}"
                       onchange="submitForm()">
            </div>
            <div class="col text-end">
                <label for="searchCondition">검색조건</label>
                <select name="searchCondition" id="searchCondition" class="form-select" onchange="submitForm()">
                    <option value="강사명" <c:if test="${condition.searchCondition == '강사명'}">selected</c:if>>강사명</option>
                    <option value="레슨명" <c:if test="${condition.searchCondition == '레슨명'}">selected</c:if>>레슨명</option>
                    <option value="과목" <c:if test="${condition.searchCondition == '과목'}">selected</c:if>>과목</option>
                </select>
            </div>
            <div class="col pt-4">
                <input type="text" class="form-control border" name="searchKeyword" value="${condition.searchKeyword}"
                       onchange="submitForm()"/>
            </div>
            <div class="col-1 pt-4">
                <label for="search"> </label>
                <button type="submit" class="btn btn-primary" id="search">검색</button>
            </div>
        </div>
    </form>

    <div class="row">
        <table class="table">
            <colgroup>
                <col width="15%">
                <col width="*">
                <col width="10%">
                <col width="10%">
                <col width="10%">
                <col width="10%">
                <col width="10%">
            </colgroup>
            <tr>
                <th>번호</th>
                <th>레슨명</th>
                <th>강사명</th>
                <th>가격</th>
                <th>상태</th>
                <th>예약날짜</th>
                <th>예약상태</th>
                <th></th>
            </tr>
            <c:forEach var="reservation" items="${lessonReservations}" varStatus="loop">
                <tr>
                    <td>${loop.index + 1}</td>
                    <td><a href="/lesson/reservation/detail?reservationNo=${reservation.no}"
                            style="text-decoration:none">${reservation.lesson.title}</a></td>
                    <td>${reservation.lesson.lecturer.name}</td>
                    <td><fmt:formatNumber value="${reservation.lesson.price}" pattern="#,###"/></td>
                    <td>${reservation.lesson.status}</td>
                    <fmt:parseDate value="${reservation.reservationCreatedDate }" pattern="yyyy-MM-dd'T'HH:mm"
                                   var="parsedDateTime" type="both"/>
                    <td><fmt:formatDate pattern="yyyy-MM-dd" value="${ parsedDateTime }"/></td>
                    <td>
                        <c:if test="${reservation.status eq '예약'}">
                            <span class="badge bg-success">예약</span>
                        </c:if>
                        <c:if test="${reservation.status eq '취소'}">
                            <span class="badge bg-danger">취소</span>
                        </c:if>
                        <c:if test="${reservation.status eq '수강종료'}">
                            <span class="badge bg-secondary">수강종료</span>
                        </c:if>
                    </td>
                    <td>
                        <c:if test="${not empty reservation.status and
                             reservation.status ne '취소' and
                             reservation.status ne '수강종료'}">
                            <form action="/pay/cancel" name="paymentDto" method="POST" style="display: inline;"
                                  id="cancel-form">
                                <input type="hidden" name="paymentId" value="${reservation.payment.id}">
                                <input type="hidden" name="userId" value="${loginUser.id}">
                                <input type="hidden" name="lessonNo" value="${reservation.lesson.lessonNo}">
                                <input type="hidden" name="totalAmount" value="${reservation.lesson.price}">
                                <input type="hidden" name="type" value="레슨">
                                <button type="button" id="cancel-btn" class="btn btn-sm btn-danger"
                                        onclick="confirmCancel()">취소
                                </button>
                            </form>
                        </c:if>
                    </td>
                </tr>
            </c:forEach>
            <c:if test="${empty lessonReservations}">
                <tr>
                    <td colspan="8">
                        <div class="row justify-content-center mb-2">
                            선택하신 예약 상태의 레슨이 존재하지 않습니다.
                        </div>
                        <div class="row justify-content-center">
                            <a href="schedule" class="btn btn-primary btn-sm" style="width: 50%">레슨 일정 보러가기</a>
                        </div>
                    </td>
                </tr>
            </c:if>
        </table>
    </div>
</div>
<%@include file="/WEB-INF/views/common/footer.jsp" %>
<script>
    function submitForm() {
        document.getElementById('searchForm').submit();
    }

    function confirmCancel() {
        var confirmResult = confirm("예약을 취소하시겠습니까?");
        if (confirmResult) {
            document.getElementById("cancel-form").submit();
        }
    }
</script>
</body>
</html>
