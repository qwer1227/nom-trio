<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@include file="/WEB-INF/views/common/tags.jsp" %>
<!doctype html>
<html lang="ko">
<head>
    <%@include file="/WEB-INF/views/common/common.jsp" %>
</head>
<%@include file="/WEB-INF/views/common/nav.jsp" %>
<body>
<security:authentication property="principal" var="loginUser"/>
<div class="container-xxl border align-content-center" id="wrap">
    <div class="row text-center mb-5">
        <h1>레슨 예약</h1>
    </div>
    <div class="row d-flex justify-content-center mb-3">
        <div class="col-5">
            <img src="${s3}/resources/images/lesson/${images['THUMBNAIL']}"
                 alt="Main Image" style="width: 100%; height: 300px;"/>
        </div>
        <div class="col-5">
            <table class="table">
                <colgroup>
                    <col width="15%">
                    <col width="*%">
                </colgroup>
                <tr>
                    <th>레슨명</th>
                    <td><a href="/lesson/detail?lessonNo=${lessonDto.lessonNo}">${lessonDto.title}</a></td>
                </tr>
                <tr>
                    <th>과목</th>
                    <td>${lessonDto.subject}</td>
                </tr>
                <tr>
                    <th>강사명</th>
                    <td>${lessonDto.lecturerName}</td>
                </tr>
                <tr>
                    <th>레슨장소</th>
                    <td>
                        ${lessonDto.place}
                    </td>
                </tr>
                <tr>
                    <th>레슨날짜</th>
                    <td>
                        ${lessonDto.startDate} ${lessonDto.startTime}
                    </td>
                </tr>
                <tr>
                    <th>참여인원</th>
                    <td>
                        ${lessonDto.participant}/5
                    </td>
                </tr>
                <tr>
                    <th>결제금액</th>
                    <td><fmt:formatNumber value="${lessonDto.price}" pattern="#,###"/>원</td>
                </tr>
            </table>
        </div>
    </div>
    <div class="row">
        <div class="col-1"></div>
        <div class="col">
            <button type="button" id="btn-pay-ready" class="btn btn-dark w-100">결제하기</button>
        </div>
        <div class="col-1"></div>
    </div>
</div>
<%@include file="/WEB-INF/views/common/footer.jsp" %>

<script type="text/javascript">
    $(function () {
        $("#btn-pay-ready").click(function (e) {
            let data = {
                lessonNo: ${lessonDto.lessonNo},
                title: '${lessonDto.title}',    // 카카오페이에 보낼 대표 상품명
                totalAmount: ${lessonDto.price},
                quantity: 1, // 총 개수
                userId: '${loginUser.id}',
                type: "레슨"
            };

            $.ajax({
                type: 'POST',
                url: '/pay/ready',
                data: JSON.stringify(data),
                contentType: 'application/json',
                success: function (response) {
                    // response => {tid:"xxx", next_redirect_pc_url:"카카오결재화면URL"}
                    location.href = response.next_redirect_pc_url;
                },
                error: function (xhr, status, error) {
                    alert('결제 준비 중 문제가 발생했습니다: ' + error);
                }
            });
        });
    });
</script>
</body>
</html>