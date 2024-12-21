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
        <h2>코스</h2>
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

    <%-- 검색 기능 --%>
    <div class="row row-cols-1 row-cols-md-1 g-4 mt-3 mb-3">
        <div class="col" style="border: 1px solid black; padding: 20px">
            <form id="form-search" method="get" action="list">
                <input type="hidden" name="page"/>
                <div class="row g-3 d-flex justify-content-center">
                    <div class="col-2 text-start">
                        <label for="customRange2" class="form-label text-start">추천순</label>
                        <input type="checkbox"  class="form-check" name="sort" value="like" ${param.sort eq 'like' ? 'checked' : ''}>
                    </div>
                    <div class="col-4">
                        <label id="slider" for="customRange2" class="form-label">거리(KM)</label>
                        <input type="range" class="form-range" min="0" max="10" id="customRange2" name="distance"
                               value="${empty param.distance ? '10' : param.distance}">
                        <div class="row">
                            <div class="col">0</div>
                            <div class="col">1</div>
                            <div class="col">2</div>
                            <div class="col">3</div>
                            <div class="col">4</div>
                            <div class="col">5</div>
                            <div class="col">6</div>
                            <div class="col">7</div>
                            <div class="col">8</div>
                            <div class="col">9</div>
                            <div class="col">10</div>
                        </div>
                    </div>
                    <div class="col-1">
                        난이도
                        <select class="form-select" name="level">
                            <option value=""> 전체</option>
                            <c:forEach var="num" begin="1" end="5">
                                <option value="${num }" ${param.level eq num ? "selected" : ""}> ${num }단계</option>
                            </c:forEach>
                        </select>
                    </div>
                    <div class="col-1">
                        지역
                        <select class="form-control" name="region" style="appearance: auto;">
                            <option value="si" ${param.region eq 'si' ? 'selected' : ''}>시/도</option>
                            <option value="gu" ${param.region eq 'gu' ? 'selected' : ''}>구</option>
                            <option value="dong" ${param.region eq 'dong' ? 'selected' : ''}>동</option>
                        </select>
                    </div>
                    <div class="col-2">
                        지역 검색
                        <input type="text" class="form-control" name="keyword" value="${param.keyword}">
                    </div>
                    <div class="col-1 pt-4">
                        <button type="button" class="btn btn-outline-primary" onclick="searchKeyword()">검색 버튼</button>
                    </div>
                </div>
            </form>
        </div>
    </div>

    <%-- 안내 문구 --%>
    <div class="card row row-cols-1 row-cols-md-1 g-4 mt-3 mb-3" align="left">
        <h5>* <strong style="background-color: orange">등록하기</strong>를 클릭하여 도전할 코스 목록에 추가하면,
            나의 코스 기록에서 코스를 확인하실 수 있습니다.</h5>
        <h5>* 이전 난이도 코스 3개를 완주해야 다음 난이도의 코스에 도전하실 수 있습니다. (ex 1단계 3개 클리어 시, 2단계 도전 가능)</h5>
    </div>

    <%-- 코스 목록 --%>
    <div class="row row-cols-1 row-cols-md-4 g-4 mt-5 mb-3">
        <c:forEach var="course" items="${courses }">
            <div class="col-3">
                <div class="card h-100">
                    <a class="text-decoration-none" href="detail?no=${course.no }">
                        <div class="main_image" style="position: relative;">
                            <img src="https://2404-bucket-team-1.s3.ap-northeast-2.amazonaws.com/resources/images/course/${course.filename }"
                                class="card-img-top" alt="..." width="200" height="200">
                            <%-- 해당 코스 완주를 성공한 사용자라면, 안내 문구를 표시한다. --%>
                            <c:if test="${course.successWhether.courseNo == '1'}">
                                <span class="badge bg-primary main_image_text"
                                      style="position: absolute; top: 50%; left: 50%; transform: translate(-50%, -50%); font-size: 20px;">
                                    완주 성공!
                                </span>
                            </c:if>
                        </div>
                    </a>
                    <div class="card-body">
                        <h5 class="card-title">
                            <span>${course.name }</span>
                        </h5>
                        <a class="text-decoration-none" href="detail?no=${course.no }">
                            <p class="card-text">${course.region.si } ${course.region.gu } ${course.region.dong }</p>
                        </a>
                            <sec:authorize access="isAuthenticated()">
                                <c:choose>
                                    <%-- 현재 도전 가능한 단계(난이도)가 코스 난이도보다 적으면, 안내 문구를 표시한다. --%>
                                    <c:when test="${currentUserLevel < course.level}">
                                        <button class="btn btn-danger disabled">아직 도전할 수 없습니다</button>
                                    </c:when>
                                    <c:otherwise>
                                        <c:choose>
                                            <%-- 사용자가 코스 도전 등록을 했다면 등록 취소 버튼을 표시하고, 클릭하면 코스 등록을 취소한다. --%>
                                            <c:when test="${course.challengeWhether.courseNo == '1'}">
                                                <a href="controlChallenge?courseNo=${course.no}&page=${pagination.page}&sort=${param.sort}&distance=${param.distance}&level=${param.level}&keyword=${param.keyword}"
                                                   class="btn btn-danger" onclick="cancelChallenge(event)">등록 취소</a>
                                            </c:when>
                                            <%-- 사용자가 코스 도전 등록을 하지 않았다면 등록하기 버튼을 표시하고, 클릭하면 코스를 등록한다. --%>
                                            <c:otherwise>
                                                <a href="controlChallenge?courseNo=${course.no}&page=${pagination.page}&sort=${param.sort}&distance=${param.distance}&level=${param.level}&keyword=${param.keyword}"
                                                   class="btn btn-warning" onclick="registerChallenge(event)">등록하기</a>
                                            </c:otherwise>
                                        </c:choose>
                                    </c:otherwise>
                                </c:choose>
                            </sec:authorize>
                    </div>
                    <div class="card-footer bg-transparent border-primary" >
                        <span class="badge rounded-pill text-bg-dark">난이도 ${course.level }단계</span>
                        <span class="badge rounded-pill text-bg-dark">거리 ${course.distance }KM</span>
                        <span class="badge rounded-pill text-bg-danger">♡ ${course.likeCnt }개</span>
                        <span></span>
                    </div>
                </div>
            </div>
        </c:forEach>
    </div>
</div>

<!-- 코스 목록 - 페이징 내비게이션 -->
<div class="row mb-3">
    <div class="col-12">
        <nav>
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
        </nav>
    </div>
</div>

<%@include file="/WEB-INF/views/common/footer.jsp" %>
<script type="text/javascript">
    // form 태그를 가져온다.
    let form = document.querySelector("#form-search");
    let pageInput = document.querySelector("input[name=page]");

    // 검색 버튼을 클릭했을 때, 요청 파라미터 정보를 제출한다.
    function searchKeyword() {
        pageInput.value = 1;
        form.submit();
    }

    // 코스 목록의 페이지 번호를 클릭했을 때, 요청 파라미터 정보를 제출한다.
    function changePage(page, event) {
        event.preventDefault();

        pageInput.value = page;
        form.submit();
    }

    // 등록하기 버튼을 클릭하면, 확인창을 표시한다.
    function registerChallenge(event) {
        if (confirm("도전할 코스 목록에 추가하시겠습니까?")) {
            alert("도전할 코스 목록에 추가되었습니다.");
        } else {
            event.preventDefault();
        }
    }

    // 등록 취소 버튼을 클릭하면, 확인창을 표시한다.
    function cancelChallenge(event) {
        if (confirm("도전할 코스 목록에서 제외하시겠습니까?")) {
            alert("도전할 코스 목록에서 제외되었습니다.");
        } else {
            event.preventDefault();
        }
    }
</script>
</body>
</html>