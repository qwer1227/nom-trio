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
        <h4>코스 달성 수 순위</h4>
        <h6>모든 사용자의 코스 달성 수 순위를 확인할 수 있습니다.</h6>
    </div>

    <%-- 로그인한 사용자의 코스 달성 수 순위 --%>
    <table class="table mt-4">
        <%-- 로그인한 경우, 나의 코스 달성 수 순위를 표시한다. --%>
        <sec:authorize access="isAuthenticated()">
            <sec:authentication property="principal" var="loginUser"/>
            <c:if test="${!empty loginUser}">
                <c:choose>
                    <%-- 로그인한 사용자가 코스를 달성한 기록이 있을 경우, 사용자의 코스 달성 수 순위를 표시한다. --%>
                    <c:when test="${successCountRank != null}">
                        <thead>
                        <tr class="table-warning">
                            <th scope="col">나의 순위</th>
                            <th scope="col">나의 닉네임</th>
                            <th scope="col">나의 코스 달성 수</th>
                            <th scope="col">달성한 코스</th>
                        </tr>
                        </thead>
                        <tbody>
                        <tr>
                            <th>${successCountRank.ranking}</th>
                            <td>${successCountRank.nickName}</td>
                            <td>${successCountRank.successCount}</td>
                            <td><button class="btn btn-primary" onclick="showMySuccessCourses()">달성한 코스 목록</button></td>
                        </tr>
                        </tbody>
                    </c:when>
                    <%-- 로그인한 사용자가 코스를 달성한 기록이 없을 경우, 안내 문구를 표시한다. --%>
                    <c:otherwise>
                        <thead>
                        <tr class="table-warning">
                            <th scope="col">나의 순위</th>
                            <th scope="col">나의 닉네임</th>
                            <th scope="col">나의 코스 달성 수</th>
                            <th scope="col">달성한 코스</th>
                        </tr>
                        </thead>
                        <tbody>
                        <tr>
                            <th colspan="4">완주한 코스가 없어서 기록이 존재하지 않습니다.</th>
                        </tr>
                        </tbody>
                    </c:otherwise>
                </c:choose>
            </c:if>
        </sec:authorize>
        <%-- 로그인하지 않은 경우, 안내 문구를 표시한다. --%>
        <c:if test="${empty loginUser}">
            <tr>
                <td>로그인 후 나의 순위를 확인할 수 있습니다.</td>
            </tr>
        </c:if>
    </table>

    <%-- 모든 사용자의 코스 달성 수 순위 --%>
    <table class="table mt-5">
        <thead>
            <tr class="table-info">
                <th scope="col">순위</th>
                <th scope="col">닉네임</th>
                <th scope="col">코스 달성 수</th>
                <th scope="col">달성한 코스</th>
            </tr>
        </thead>
        <tbody>
            <c:forEach var="successCountRank" items="${successCountRanks}">
                <tr>
                    <th>${successCountRank.ranking}</th>
                    <td>${successCountRank.nickName}</td>
                    <td>${successCountRank.successCount}</td>
                    <td><button class="btn btn-primary" onclick="showOtherSuccessCourses(${successCountRank.userNo})">달성한 코스 목록</button></td>
                </tr>
            </c:forEach>
        </tbody>
    </table>

    <%-- 페이징 처리 --%>
    <div class="row mb-3">
        <div class="col-12">
            <nav>
                <form id="form-pagination" method="get" action="success-count-ranking">
                    <input type="hidden" name="page"/>
                    <ul class="pagination justify-content-center">
                        <li class="page-item ${pagination.first ? 'disabled' : '' }">
                            <a class="page-link"
                               onclick="changePage(${pagination.prevPage}, event)"
                               href="list?page=${pagination.prevPage}">이전</a>
                        </li>

                        <c:forEach var="num" begin="${pagination.beginPage }" end="${pagination.endPage }">
                            <li class="page-item ${pagination.page eq num ? 'active' : '' }">
                                <a class="page-link"
                                   onclick="changePage(${num }, event)"
                                   href="list?page=${num }">${num }</a>
                            </li>
                        </c:forEach>

                        <li class="page-item ${pagination.last ? 'disabled' : '' }">
                            <a class="page-link"
                               onclick="changePage(${pagination.nextPage}, event)"
                               href="list?page=${pagination.nextPage}">다음</a>
                        </li>
                    </ul>
                </form>
            </nav>
        </div>
    </div>
</div>

<%-- 달성한 코스 목록 Modal창 --%>
<div class="modal fade" id="modal-success-courses" tabindex="-1" aria-labelledby="modal-success-courses" aria-hidden="true">
    <div class="modal-dialog modal-lg">
        <div class="modal-content">
            <%-- 달성한 코스 목록 --%>
            <div class="modal-header">
                <h1 class="modal-title fs-5" id="modal-user-success-courses"></h1>
                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <div class="modal-body">
                <table class="table" id="success-courses">
                    <thead>
                        <tr class="table-info">
                            <th scope="col">번호</th>
                            <th scope="col">코스 이름</th>
                            <th scope="col">코스 거리</th>
                            <th scope="col">코스 난이도</th>
                            <th scope="col">완주 횟수</th>
                        </tr>
                    </thead>
                    <tbody></tbody>
                </table>
            </div>

            <%-- 페이징 처리 --%>
            <div class="row mb-3">
                <div class="col-12">
                    <nav>
                        <ul class="pagination justify-content-center" id="current-paging"></ul>
                    </nav>
                </div>
            </div>

            <%-- 닫기 버튼 --%>
            <div class="modal-footer">
                <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">닫기</button>
            </div>
        </div>
    </div>
</div>

<%@include file="/WEB-INF/views/common/footer.jsp" %>
<script type="text/javascript">
    let form = document.querySelector("#form-pagination");
    let pageInput = document.querySelector("input[name=page]");

    // 페이지를 선택할 때마다 해당 페이지로 이동한다.
    function changePage(page, event) {
        event.preventDefault();

        pageInput.value = page;
        form.submit();
    }

    let modal = new bootstrap.Modal("#modal-success-courses");

    // 로그인한 사용자가 달성한 코스 목록을 보여준다.
    function showMySuccessCourses() {
        getMySuccessCourses(1);
    }

    async function getMySuccessCourses(page, event) {
        // 1. 페이지 클릭 시, 링크 이동을 방지한다.
        if (event) {
            event.preventDefault();
        }

        // 2. 달성한 코스 목록, 페이징 처리 정보를 가져온다.
        let response = await fetch("/course/mySuccessCourses?page=" + page);

        // 3. 데이터를 javascript 객체로 변환하고, 변수에 저장한다.
        let result = await response.json();
        let mySuccessCourses = result.data;
        let paging = result.paging;
        let num = paging.begin;
        let nickname = mySuccessCourses[0].nickname;

        // 4. 로그인한 사용자의 닉네임을 화면에 표시한다.
        let name = "";

        name = `
            \${nickname}님의 달성한 코스 목록
        `;

        document.querySelector("#modal-user-success-courses").innerHTML = name;

        // 5. 달성한 코스 목록을 화면에 표시한다.
        let rows = "";

        for (let mySuccessCourse of mySuccessCourses) {
            rows += `
                <tr>
                    <th><span>\${num}</span></th>
                    <td><a href="detail?no=\${mySuccessCourse.courseNo}"><span>\${mySuccessCourse.courseName}</span></a></td>
                    <td><span>\${mySuccessCourse.distance}KM</span></td>
                    <td><span>\${mySuccessCourse.level}단계</span></td>
                    <td><span>\${mySuccessCourse.successCount}회</span></td>
                </tr>
            `;
            num++;
        }

        document.querySelector("#success-courses tbody").innerHTML = rows;

        // 6. 페이징 처리 기능을 화면에 표시한다.
        let pages = "";

        pages += `
            <li class="page-item \${paging.first ? 'disabled' : ''}">
                <a class="page-link" href="" onclick="getMySuccessCourses(\${paging.prevPage}, event)">이전</a>
            </li>
        `;

        for (let num = paging.beginPage; num <= paging.endPage; num++) {
            pages += `
                <li class="page-item ">
                    <a class="page-link \${paging.page == num ? 'active' : ''}"
                        href="" onclick="getMySuccessCourses(\${num}, event)">\${num}</a>
                </li>
            `;
        }

        pages += `
            <li class="page-item \${paging.last ? 'disabled' : ''}">
                <a class="page-link" href="" onclick="getMySuccessCourses(\${paging.nextPage}, event)">다음</a>
            </li>
        `;

        document.querySelector("#current-paging").innerHTML = pages;

        // 7. Modal창을 화면에 표시한다.
        modal.show();
    }

    // 모든 사용자가 달성한 코스 목록을 보여준다.
    function showOtherSuccessCourses(userNo) {
        getOtherSuccessCourses(1, userNo);
    }

    async function getOtherSuccessCourses(page, userNo, event) {
        // 1. 페이지 클릭 시, 링크 이동을 방지한다.
        if (event) {
            event.preventDefault();
        }

        // 2. 달성한 코스 목록, 페이징 처리 정보를 가져온다.
        let response = await fetch("/course/otherSuccessCourses?page=" + page + "&userNo=" + userNo);

        // 3. 데이터를 javascript 객체로 변환하고, 변수에 저장한다.
        let result = await response.json();
        let otherSuccessCourses = result.data;
        let paging = result.paging;
        let num = paging.begin;
        let nickname = otherSuccessCourses[0].nickname;

        // 4. 사용자의 닉네임을 화면에 표시한다.
        let name = "";

        name = `
            \${nickname}님의 달성한 코스 목록
        `;

        document.querySelector("#modal-user-success-courses").innerHTML = name;

        // 5. 달성한 코스 목록을 화면에 표시한다.
        let rows = "";

        for (let otherSuccessCourse of otherSuccessCourses) {
            rows += `
                <tr>
                    <th><span>\${num}</span></th>
                    <td><a href="detail?no=\${otherSuccessCourse.courseNo}"><span>\${otherSuccessCourse.courseName}</span></a></td>
                    <td><span>\${otherSuccessCourse.distance}KM</span></td>
                    <td><span>\${otherSuccessCourse.level}단계</span></td>
                    <td><span>\${otherSuccessCourse.successCount}회</span></td>
                </tr>
            `;
            num++;
        }

        document.querySelector("#success-courses tbody").innerHTML = rows;

        // 6. 페이징 처리 기능을 화면에 표시한다.
        let pages = "";

        pages += `
            <li class="page-item \${paging.first ? 'disabled' : ''}">
                <a class="page-link" href="" onclick="getOtherSuccessCourses(\${paging.prevPage}, \${userNo}, event)">이전</a>
            </li>
        `;

        for (let num = paging.beginPage; num <= paging.endPage; num++) {
            pages += `
                <li class="page-item ">
                    <a class="page-link \${paging.page == num ? 'active' : ''}"
                        href="" onclick="getOtherSuccessCourses(\${num}, \${userNo}, event)">\${num}</a>
                </li>
            `;
        }

        pages += `
            <li class="page-item \${paging.last ? 'disabled' : ''}">
                <a class="page-link" href="" onclick="getOtherSuccessCourses(\${paging.nextPage}, \${userNo}, event)">다음</a>
            </li>
        `;

        document.querySelector("#current-paging").innerHTML = pages;

        // 7. Modal창을 화면에 표시한다.
        modal.show();
    }
</script>
</body>
</html>