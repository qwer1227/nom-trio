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
        <h2>나의 코스 기록</h2>
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

    <sec:authorize access="isAuthenticated()">
        <sec:authentication property="principal" var="loginUser" />
    </sec:authorize>

    <div class="row row-cols-1 row-cols-md-1 g-4 mt-3">
        <div class="col">
            <c:choose>
                <%-- 로그인한 경우 로그인한 사용자의 배지와 코스 완주 기록, 도전할 코스 목록을 표시한다. --%>
                <c:when test="${not empty loginUser}">
                    <%-- 안내 문구 --%>
                    <div class="card g-4 mb-3" align="left" style="padding: 10px 10px 10px 10px;">
                        <h5>* <strong style="background-color: green; color: white;">완주 기록 등록</strong>을 클릭하여 완주 기록 목록에 추가하면,
                            <strong style="background-color: blue; color: white;">완주 기록 보기</strong>를 클릭하여 등록한 완주 기록을 확인하실 수 있습니다.</h5>
                    </div>

                    <%-- 로그인한 사용자의 배지와 코스 완주 기록 --%>
                    <table class="table table-bordered">
                        <div class="card">
                            <div class="card-header">나의 배지와 코스 기록</div>
                        </div>
                        <tbody>
                        <tr>
                            <th scope="row">닉네임</th>
                            <td>${loginUser.nickname}</td>
                        </tr>
                        <tr>
                            <th scope="row">현재 배지</th>
                            <td>
                                <%-- 배지가 있다면 배지 목록을 표시하고, 배지가 없다면 안내 문구를 표시한다. --%>
                                <c:choose>
                                    <c:when test="${not empty userBadges}">
                                        <c:forEach var="userBadge" items="${userBadges}">
                                            <div>
                                                <img src="https://2404-bucket-team-1.s3.ap-northeast-2.amazonaws.com/resources/images/badge/${userBadge.badge.image}" width="40px" height="40px">
                                                    ${userBadge.badge.name} : ${userBadge.badge.description}
                                            </div>
                                        </c:forEach>
                                    </c:when>
                                    <c:otherwise>
                                        <div>획득한 배지가 없습니다.</div>
                                    </c:otherwise>
                                </c:choose>
                            </td>
                        </tr>
                        <tr>
                            <th scope="row">현재 도전 가능한 난이도</th>
                            <td>${userLevel.level}단계</td>
                        </tr>
                        <tr>
                            <th scope="row">나의 완주 기록</th>
                            <td><button class="btn btn-primary" onclick="showFinishRecords()">완주 기록 보기</button></td>
                        </tr>
                        </tbody>
                    </table>

                    <%-- 로그인한 사용자가 지정한 도전할 코스 목록 --%>
                    <div class="card">
                        <div class="card-header">도전할 코스 목록</div>
                    </div>
                    <table class="table">
                        <thead>
                            <tr class="table-info">
                                <th scope="col">번호</th>
                                <th scope="col">이름</th>
                                <th scope="col">지역</th>
                                <th scope="col">거리</th>
                                <th scope="col">난이도</th>
                                <th scope="col">완주 기록 등록</th>
                                <th scope="col"></th>
                            </tr>
                        </thead>
                        <tbody>
                        <%-- 도전 등록한 코스가 있다면 도전할 코스 목록을 표시하고, 없다면 안내 문구를 표시한다. --%>
                        <c:choose>
                            <c:when test="${not empty coursesToChallenge}">
                                <c:forEach var="courseToChallenge" items="${coursesToChallenge}" varStatus="loop">
                                    <tr>
                                        <td><span>${pagination.begin + loop.index}</span></td>
                                        <td><a href="detail?no=${courseToChallenge.no}"><span>${courseToChallenge.name}</span></a></td>
                                        <td><span>${courseToChallenge.region.si} ${courseToChallenge.region.gu} ${courseToChallenge.region.dong}</span></td>
                                        <td><span>${courseToChallenge.distance}KM</span></td>
                                        <td><span>${courseToChallenge.level}단계</span></td>
                                        <td>
                                            <span>
                                                <button class="btn btn-success"
                                                        onclick="openAddRecordFormModal(${courseToChallenge.no}, '${courseToChallenge.name}')">완주 기록 등록</button>
                                            </span>
                                        </td>
                                        <td>
                                            <span>
                                                <a href="cancelChallenge?courseNo=${courseToChallenge.no}&page=${pagination.page}"
                                                   class="btn btn-danger" onclick="cancelChallenge(event)">삭제</a>
                                            </span>
                                        </td>
                                    </tr>
                                </c:forEach>
                            </c:when>
                            <c:otherwise>
                                <tr>
                                    <td colspan="6">
                                        <div>
                                            등록한 코스가 없습니다.
                                            코스 목록에서 도전할 코스를 등록할 수 있습니다 <a href="list" class="btn btn-primary">코스 목록</a>
                                        </div>
                                    </td>
                                </tr>
                            </c:otherwise>
                        </c:choose>
                        </tbody>
                    </table>
                </c:when>
                <%-- 로그인하지 않은 경우 안내 문구를 표시한다. --%>
                <c:otherwise>
                    <table class="table table-bordered">
                        <th colspan="4">로그인하면 나의 배지와 코스 기록을 확인할 수 있습니다.</th>
                    </table>
                </c:otherwise>
            </c:choose>
        </div>
    </div>
</div>

<!-- 페이징 내비게이션 -->
<c:if test="${not empty coursesToChallenge}">
    <div class="row mb-3">
        <div class="col-12">
            <nav>
                <form id="form-myCoursesToChallenge" method="get" action="my-course">
                    <input type="hidden" name="page"/>
                    <ul class="pagination justify-content-center">
                        <li class="page-item ${pagination.first ? 'disabled' : '' }">
                            <a class="page-link"
                               onclick="changePage(${pagination.prevPage}, event)"
                               href="my-course?page=${pagination.prevPage}">이전</a>
                        </li>

                        <c:forEach var="num" begin="${pagination.beginPage }" end="${pagination.endPage }">
                            <li class="page-item ${pagination.page eq num ? 'active' : '' }">
                                <a class="page-link"
                                   onclick="changePage(${num }, event)"
                                   href="my-course?page=${num }">${num }</a>
                            </li>
                        </c:forEach>

                        <li class="page-item ${pagination.last ? 'disabled' : '' }">
                            <a class="page-link"
                               onclick="changePage(${pagination.nextPage}, event)"
                               href="my-course?page=${pagination.nextPage}">다음</a>
                        </li>
                    </ul>
                </form>
            </nav>
        </div>
    </div>
</c:if>

<%-- 완주 기록 보기 Modal창 --%>
<div class="modal fade" id="modal-finish-records" tabindex="-1" aria-labelledby="modal-finish-records" aria-hidden="true">
    <div class="modal-dialog modal-lg">
        <div class="modal-content">
            <%-- 완주 기록 목록 --%>
            <div class="modal-header">
                <h1 class="modal-title fs-5" id="modal-user-finish-records">${loginUser.nickname}님의 코스 완주 기록</h1>
                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <div class="modal-body">
                <table class="table" id="finish-records">
                    <thead>
                        <tr class="table-info">
                            <th scope="col">번호</th>
                            <th scope="col">코스 이름</th>
                            <th scope="col">코스 거리</th>
                            <th scope="col">코스 난이도</th>
                            <th scope="col">완주 날짜</th>
                            <th scope="col">완주 시간</th>
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

<%-- 코스 완주 기록 등록 Modal창 --%>
<div class="modal fade" id="modal-add-record-form" tabindex="-1" aria-labelledby="exampleModalLabel" aria-hidden="true">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title">코스 완주 기록 등록하기</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <%-- 완주 날짜와 완주 시간을 입력하고 등록한다. --%>
            <div class="modal-body">
                <div class="form-group">
                    <label class="form-label">1. 코스 이름</label>
                    <input id="name" class="form-control" type="text" aria-label="Disabled input example" disabled readonly>
                </div>
                <form method="post" action="/addRecord" enctype="multipart/form-data">
                    <input type="hidden" name="courseNo"/>
                    <div class="form-group">
                        <label class="form-label">2. 완주 날짜</label>
                        <div><input type="datetime-local" name="finishedDate" id="dateLocal"></div>
                    </div>
                    <div class="form-group">
                        <label class="form-label">3. 완주 시간</label>
                        <div class="row">
                            <div class="col">
                                시간
                                <select class="form-select" name="hour">
                                    <c:forEach var="num" begin="0" end="24">
                                        <option>${num}</option>
                                    </c:forEach>
                                </select>
                            </div>
                            <div class="col">
                                분
                                <select class="form-select" name="minute">
                                    <c:forEach var="num" begin="0" end="59">
                                        <option>${num}</option>
                                    </c:forEach>
                                </select>
                            </div>
                            <div class="col">
                                초
                                <select class="form-select" name="second">
                                    <c:forEach var="num" begin="0" end="59">
                                        <option>${num}</option>
                                    </c:forEach>
                                </select>
                            </div>
                        </div>
                    </div>
                </form>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">취소</button>
                <button type="submit" class="btn btn-primary" onclick="submitRecord()">등록</button>
            </div>
        </div>
    </div>
</div>

<%@include file="/WEB-INF/views/common/footer.jsp" %>
<script type="text/javascript">
    // 도전할 코스 목록 페이지 번호를 클릭했을 때, 요청 파라미터 정보를 제출한다.
    function changePage(page, event) {
        // 1. 페이지 클릭 시, 링크 이동을 방지한다.
        event.preventDefault();

        // 2. 도전할 코스 목록 페이징 처리 태그와 페이지 번호를 가져온다.
        let form = document.querySelector("#form-myCoursesToChallenge");
        let pageInput = document.querySelector("input[name=page]");

        // 3. Controller에 요청 파라미터 정보를 제출한다.
        pageInput.value = page;
        form.submit();
    }

    // 완주 기록 등록 Modal창을 가져온다.
    let registerModal = new bootstrap.Modal('#modal-add-record-form');

    // 완주 기록 등록 버튼을 클릭하면, 완주 기록 등록 창이 열린다.
    function openAddRecordFormModal(courseNo, name) {
        // 1. 코스 번호와 코스 이름을 완주 기록 등록 Modal창에 저장한다.
        document.querySelector("input[name=courseNo]").value = courseNo;
        document.querySelector("#name").value = name;

        // 2. 완주 날짜를 오늘 날짜까지 제한한다.
        let now_utc = Date.now()
        let timeOff = new Date().getTimezoneOffset()*60000;
        let today = new Date(now_utc-timeOff).toISOString().substring(0, 16);
        document.getElementById("dateLocal").setAttribute("max", today);

        // 3. 완주 기록 등록 창이 열린다.
        registerModal.show();
    }

    // 입력한 완주 기록(완주 날짜, 완주 시간)를 컨트롤러에 제출한다.
    async function submitRecord() {
        // 1. 입력한 완주 기록을 가져온다.
        let courseNo = document.querySelector("input[name=courseNo]").value;
        let finishedDate = document.querySelector("input[name=finishedDate]").value;
        let hour = document.querySelector("select[name=hour]").value;
        let minute = document.querySelector("select[name=minute]").value;
        let second = document.querySelector("select[name=second]").value;

        // 2. 완주 기록이 비어있다면, 경고 메시지를 출력한다.
        if (finishedDate === "" && hour === '0' && minute === '0' && second === '0') {
            alert("완주 날짜와 완주 시간 작성은 필수입니다.");
            return;
        }

        if (finishedDate === "") {
            alert("완주 날짜 작성은 필수입니다.");
            return;
        }

        if (hour === '0' && minute === '0' && second === '0') {
            alert("완주 시간 작성은 필수입니다.");
            return;
        }

        // 3. 입력한 완주 기록 정보를 formData 객체에 저장한다.
        let formData = new FormData();
        formData.append("courseNo", courseNo);
        formData.append("finishedDate", finishedDate);
        formData.append("hour", hour);
        formData.append("minute", minute);
        formData.append("second", second);

        // 4. formData(입력한 완주 기록 정보)를 서버에 보낸다.
        let response = await fetch("/ajax/addRecord", {
            method: "POST",
            body: formData
        });

        // 5. 요청 처리 성공 확인 후, 알림창을 표시하고 modal창을 숨긴다.
        if (response.ok) {
            alert("코스 완주 기록 입력이 성공했습니다!");
            registerModal.hide();
        }
    }

    // 삭제 버튼을 클릭하면, 확인창이 표시된다.
    function cancelChallenge(event) {
        if (confirm("도전할 코스 목록에서 제외하시겠습니까?")) {
            alert("도전할 코스 목록에서 제외되었습니다.");
        } else {
            event.preventDefault();
        }
    }

    // 완주 기록 보기 Modal창을 가져온다.
    let myModal = new bootstrap.Modal('#modal-finish-records');

    // 완주 기록 보기 버튼을 클릭하면, 로그인한 사용자의 완주 기록을 보여준다.
    function showFinishRecords() {
        getFinishRecords(1);
    }

    async function getFinishRecords(page, event) {
        // 1. 페이지 클릭 시 링크 이동을 방지한다.
        if (event) {
            event.preventDefault();
        }

        // 2. 완주 기록, 페이징 처리 정보 데이터를 가져온다.
        let response = await fetch("/course/finishRecords?page=" + page);

        // 3. 데이터를 javascript 객체로 변환하고, 변수에 저장한다.
        let result = await response.json();
        let records = result.data;
        let paging = result.paging;
        let num = paging.begin;

        // 4. 완주 기록이 있다면, 완주 기록 목록을 표시하고 페이징 처리 기능을 구현한다.
        if (records.length > 0) {
            // 완주 기록 목록 표시
            let rows = "";

            for (let record of records) {
                rows += `
                    <tr>
                        <th><span>\${num}</span></th>
                        <td><a href="detail?no=\${record.course.no}"><span>\${record.course.name}</span></a></td>
                        <td><span>\${record.course.distance}KM</span></td>
                        <td><span>\${record.course.level}단계</span></td>
                        <td><span>\${record.finishedDate}</span></td>
                        <td id="time"></td>
                    </tr>
                `;
                num++;
            }

            document.querySelector("#finish-records tbody").innerHTML = rows;

            // 완주 기록 - 시, 분, 초 표시
            let time = document.querySelectorAll("#time");
            let timeContent = "";

            for (let r = 0; r < records.length; r++) {
                let record = records[r];

                if (record.hour !== 0) {
                    timeContent = `
                        <span>\${record.hour}시간 \${record.minute}분 \${record.second}초</span>
                    `;
                } else {
                    timeContent = `
                        <span>\${record.minute}분 \${record.second}초</span>
                    `;
                }

                time[r].innerHTML = timeContent;
            }

            // 페이징 처리 기능 구현
            let pages = "";

            pages += `
                <li class="page-item \${paging.first ? 'disabled' : ''}">
                    <a class="page-link" href="" onclick="getFinishRecords(\${paging.prevPage}, event)">이전</a>
                </li>
            `

            for (let num = paging.beginPage; num <= paging.endPage; num++) {
                pages += `
                    <li class="page-item ">
                        <a class="page-link \${paging.page == num ? 'active' : ''}"
                            href="" onclick="getFinishRecords(\${num}, event)">\${num}</a>
                    </li>
                `;
            }

            pages += `
                <li class="page-item \${paging.last ? 'disabled' : ''}">
                    <a class="page-link" href="" onclick="getFinishRecords(\${paging.nextPage}, event)">다음</a>
                </li>
            `;

            document.querySelector("#current-paging").innerHTML = pages;
        } else {
            let notice = `
                <tr class="text-center">
                    <td colspan="6">완주한 코스가 없어서 기록이 없습니다.</td>
                </tr>
            `

            document.querySelector("#finish-records tbody").innerHTML = notice;
        }

        // 6. Modal창을 화면에 표시한다.
        myModal.show();
    }

</script>
</body>
</html>