<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@include file="/WEB-INF/views/common/tags.jsp" %>
<!doctype html>
<html lang="ko">
<head>
    <%@include file="/WEB-INF/views/common/common.jsp" %>
</head>
<body>
<%@include file="/WEB-INF/views/common/nav.jsp" %>
<div class="container-xxl text-center" id="wrap">

    <div class="col m-5">
        <h2>런너 랭킹</h2>
    </div>
    <%-- 카테고리 --%>
    <div class="row row-cols-2 row-cols-lg-4 g-2 g-lg-3 justify-content-center">
        <div class="col " >
            <a class="nav-link p-3 border-start border-primary border-4 bg-light" style="border-color: #0064FF;" href="my-course">나의 코스 기록</a>
        </div>
        <div class="col " >
            <a class="nav-link p-3 border-start border-primary border-4 bg-light" style="border-color: #0064FF;" href="list">코스 목록</a>
        </div>
        <div class="col " >
            <a class="nav-link p-3 border-start border-primary border-4 bg-light" style="border-color: #0064FF;" href="shortest-record-ranking">런너 랭킹</a>
        </div>
    </div>

    <%-- 런너 순위를 종류별로 선택한다. --%>
    <div class="mt-5">
        <a class="btn btn-primary" href="success-count-ranking" role="button">코스 달성 수 순위</a>
        <a class="btn btn-primary" href="shortest-record-ranking" role="button">최단 기록 순위</a>
    </div>

    <div class="mt-3">
        <h4>최단 기록 순위</h4>
        <h6>코스 별로 모든 사용자의 최단 완주 기록 순위를 확인할 수 있습니다.</h6>
    </div>

    <%-- 코스를 선택하면, 해당 코스에 대한 완주자 기록 목록이 화면에 나타난다. --%>
    <form id="form-select" method="get" action="shortest-record-ranking">
        <div class="row justify-content-center mt-4">
            <input type="hidden" name="myPage"/>
            <input type="hidden" name="allPage"/>
            <select class="form-select" aria-label="Default select example" style="width: 300px"
                    name="courseNo" onchange="changeCourse()">
                <option selected value="">코스 선택</option>
                <c:forEach var="course" items="${courses}">
                    <option value="${course.no}" ${param.courseNo eq course.no ? 'selected' : ''}>
                        ${course.name}
                    </option>
                </c:forEach>
            </select>
        </div>
    </form>

    <%-- 나의 현재 코스 완주 기록 및 순위 --%>
    <table class="table mt-4">
        <thead>
            <tr class="table-warning">
                <th scope="col">나의 순위</th>
                <th scope="col">나의 닉네임</th>
                <th scope="col">나의 완주 날짜</th>
                <th scope="col">나의 완주 기록</th>
            </tr>
        </thead>
        <tbody>
            <sec:authorize access="isAuthenticated()">
                <sec:authentication property="principal" var="loginUser" />
            </sec:authorize>

            <c:choose>
                <%-- 로그인한 경우, 나의 코스 완주 기록 혹은 안내 문구를 화면에 표시한다. --%>
                <c:when test="${not empty loginUser}">
                    <c:choose>
                        <%-- 나의 코스 완주 기록이 존재하면, 나의 코스 완주 기록을 화면에 표시한다. --%>
                        <c:when test="${not empty myRecords}">
                            <c:forEach var="record" items="${myRecords}">
                                <tr>
                                    <th scope="row">${record.no}</th>
                                    <td>${record.user.nickname}</td>
                                    <td><fmt:formatDate value="${record.finishedDate}" pattern="yyyy년 MM월 dd일 HH시 mm분" /> </td>
                                    <td><c:if test="${record.hour != 0}">${record.hour}시간</c:if> ${record.minute}분 ${record.second}초</td>
                                </tr>
                            </c:forEach>
                        </c:when>
                        <%-- 나의 코스 완주 기록이 존재하지 않다면, 안내 문구를 표시한다. --%>
                        <c:otherwise>
                            <tr>
                                <th colspan="4">기록이 존재하지 않습니다.</th>
                            </tr>
                        </c:otherwise>
                    </c:choose>
                </c:when>
                <%-- 로그인하지 않은 경우, 안내 문구를 표시한다. --%>
                <c:otherwise>
                    <tr>
                        <th colspan="4">로그인하여 기록을 확인할 수 있습니다.</th>
                    </tr>
                </c:otherwise>
            </c:choose>
        </tbody>
    </table>

    <!-- 나의 순위 - 페이징 내비게이션 -->
    <c:if test="${not empty myRecords}">
        <div class="row mb-3">
            <div class="col-12">
                <nav>
                    <ul class="pagination justify-content-center">
                        <li class="page-item ${myPaging.first ? 'disabled' : '' }">
                            <a class="page-link"
                               onclick="changeMyRankPage(${myPaging.prevPage}, 1, event)"
                               href="list?page=${myPaging.prevPage}">이전</a>
                        </li>

                        <c:forEach var="num" begin="${myPaging.beginPage }" end="${myPaging.endPage }">
                            <li class="page-item ${myPaging.page eq num ? 'active' : '' }">
                                <a class="page-link"
                                   onclick="changeMyRankPage(${num }, 1, event)"
                                   href="list?page=${num }">${num }</a>
                            </li>
                        </c:forEach>

                        <li class="page-item ${myPaging.last ? 'disabled' : '' }">
                            <a class="page-link"
                               onclick="changeMyRankPage(${myPaging.nextPage}, 1, event)"
                               href="list?page=${myPaging.nextPage}">다음</a>
                        </li>
                    </ul>
                </nav>
            </div>
        </div>
    </c:if>

    <%-- 모든 사용자의 현재 코스 완주 기록 및 순위 --%>
    <table class="table mt-5">
        <thead>
            <tr class="table-info">
                <th scope="col">순위</th>
                <th scope="col">닉네임</th>
                <th scope="col">완주 날짜</th>
                <th scope="col">완주 기록</th>
            </tr>
        </thead>
        <tbody>
            <c:choose>
                <%-- 코스에 대한 모든 사용자의 코스 완주 기록이 있다면, 코스를 완주한 모든 사용자의 기록 목록을 표시한다. --%>
                <c:when test="${not empty records}">
                    <c:forEach var="record" items="${records}">
                        <tr>
                            <th scope="row">${record.no}</th>
                            <td>${record.user.nickname}</td>
                            <td><fmt:formatDate value="${record.finishedDate}" pattern="yyyy년 MM월 dd일 HH시 mm분" /> </td>
                            <td><c:if test="${record.hour != 0}">${record.hour}시간</c:if> ${record.minute}분 ${record.second}초</td>
                        </tr>
                    </c:forEach>
                </c:when>
                <%-- 코스에 대한 모든 사용자의 코스 완주 기록이 없다면, 안내 문구를 표시한다. --%>
                <c:otherwise>
                    <tr>
                        <th colspan="4">기록이 존재하지 않습니다.</th>
                    </tr>
                </c:otherwise>
            </c:choose>
        </tbody>
    </table>

    <!-- 모든 사용자의 순위 - 페이징 내비게이션 -->
    <c:if test="${not empty records}">
        <div class="row mb-3">
            <div class="col-12">
                <nav>
                    <ul class="pagination justify-content-center">
                        <li class="page-item ${allPaging.first ? 'disabled' : '' }">
                            <a class="page-link"
                               onclick="changeAllRankPage(${allPaging.prevPage}, 1, event)"
                               href="list?page=${allPaging.prevPage}">이전</a>
                        </li>

                        <c:forEach var="num" begin="${allPaging.beginPage }" end="${allPaging.endPage }">
                            <li class="page-item ${allPaging.page eq num ? 'active' : '' }">
                                <a class="page-link"
                                   onclick="changeAllRankPage(${num }, 1, event)"
                                   href="list?page=${num }">${num }</a>
                            </li>
                        </c:forEach>

                        <li class="page-item ${allPaging.last ? 'disabled' : '' }">
                            <a class="page-link"
                               onclick="changeAllRankPage(${allPaging.nextPage}, 1, event)"
                               href="list?page=${allPaging.nextPage}">다음</a>
                        </li>
                    </ul>
                </nav>
            </div>
        </div>
    </c:if>
</div>

<%@include file="/WEB-INF/views/common/footer.jsp" %>
<script type="text/javascript">
    // form 태그를 가져온다.
    let form = document.querySelector("#form-select");
    let myPageInput = document.querySelector("input[name=myPage]");
    let allPageInput = document.querySelector("input[name=allPage]");

    // 코스를 선택할 때마다 1페이지를 요청한다.
    function changeCourse() {
        myPageInput.value = 1;
        allPageInput.value = 1;

        form.submit();
    }

    // 나의 순위 목록의 페이지 번호를 클릭했을 때, 요청 파라미터 정보를 제출한다.
    function changeMyRankPage(myPage, allPage, event) {
        // 1. 나의 순위 목록에서 페이지 번호를 클릭하면, 해당 페이지로 이동한다.
        event.preventDefault();
        myPageInput.value = myPage;

        // 2. 모든 사용자의 순위 목록의 페이지는 1로 고정된다.
        allPageInput.value = allPage;

        // 3. 요청 파라미터 정보를 제출한다.
        form.submit();
    }

    // 모든 사용자의 순위 목록의 페이지 번호를 클릭했을 때, 요청 파라미터 정보를 제출한다.
    function changeAllRankPage(allPage, myPage, event) {
        // 1. 모든 사용자의 순위 목록에서 페이지 번호를 클릭하면, 해당 페이지로 이동한다.
        event.preventDefault();
        allPageInput.value = allPage;

        // 2. 나의 순위 목록의 페이지는 1로 고정된다.
        myPageInput.value = myPage;

        // 3. 요청 파라미터 정보를 제출한다.
        form.submit();
    }
</script>
</body>
</html>