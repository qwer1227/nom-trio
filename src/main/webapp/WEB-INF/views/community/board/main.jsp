<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@include file="/WEB-INF/views/common/tags.jsp" %>
<!doctype html>
<html lang="ko">
<head>
  <%@include file="/WEB-INF/views/common/common.jsp" %>
</head>
<style>
    #content-title:hover {
        text-decoration: underline;
        font-weight: bold;
    }
</style>
<body>
<%@include file="/WEB-INF/views/common/nav.jsp" %>
<div class="container-xxl text-center" id="wrap">
  <div class="row p-3 justify-content-center">
    <div class="col mb-3">
      <h2> 커뮤니티 </h2>
    </div>
  </div>

  <div class="row">
    <div class="col-4 border" style="margin: 15px; background-color: #f2f2f2; height: 190px">
      <table>
        <tbody>
        <tr>
          <td>
            <div style="text-align: start" class="pt-2 pb-2">
              <a href="/community/notice/main" style="text-decoration-line: none; color: black; font-weight: bold">
                [ 공지사항 ]
              </a>
            </div>
            <ul style="text-align: start">
              <c:forEach var="notice" items="${notices}">
                <li class="pb-1">
                  <a href="/community/notice/hit?no=${notice.no}" style="text-decoration-line: none">
                      ${notice.title}
                  </a>
                </li>
              </c:forEach>
            </ul>
          </td>
        </tr>
        </tbody>
      </table>
    </div>

    <div class="col-4 border" style="margin: 15px; background-color: #f2f2f2; height: 190px">
      <table>
        <tbody>
        <tr>
          <td>
            <div style="text-align: start;" class="pt-2 pb-2">
              <a href="/community/crew/main" style="text-decoration-line: none; color: black; font-weight: bold">
                [ 크루모임 ]
              </a>
            </div>
            <ul style="text-align: start">
              <c:forEach var="crew" items="${crews}">
                <li class="pb-1">
                  <a href="/community/crew/hit?no=${crew.no}" style="text-decoration-line: none">
                      ${crew.title}
                    <font color="${crew.memberCnt == 4 ? 'red' : ''}">(${crew.memberCnt}/5)</font>
                  </a>
                </li>
              </c:forEach>
            </ul>
          </td>
        </tr>
        </tbody>
      </table>
    </div>
    <div class="col mt-3" style="margin: 10px; text-align: center">
      <div class="ad-popup">
        <div id="carouselExampleAutoplaying" class="carousel slide" data-bs-ride="carousel">
          <div class="carousel-inner">
            <c:forEach var="marathon" items="${marathons}">
              <div class="carousel-item active">
                <div class="popup-content text-center">
                  <a href="/community/marathon/hit?no=${marathon.no}" type="button">
                    <img src="${marathon.thumbnail}" class="d-block w-100" style="height: 190px" alt="marathon info">
                  </a>
                </div>
              </div>
              <button class="carousel-control-prev" type="button" data-bs-target="#carouselExampleAutoplaying"
                      data-bs-slide="prev">
                <span class="carousel-control-prev-icon" aria-hidden="true"></span>
                <span class="visually-hidden">Previous</span>
              </button>
              <button class="carousel-control-next" type="button" data-bs-target="#carouselExampleAutoplaying"
                      data-bs-slide="next">
                <span class="carousel-control-next-icon" aria-hidden="true"></span>
                <span class="visually-hidden">Next</span>
              </button>
            </c:forEach>
          </div>
        </div>
      </div>
    </div>

    <!-- 게시글 정렬 기능 -->
    <form id="form-search" method="get" action="main">
      <input type="hidden" name="page" value="${param.page != null ? param.page : 1}">
      <input type="hidden" name="category" id="categoryInput" value="${param.category }">
      <!-- 카테고리 종류에 따른 게시글 목록 반환 기능 -->
      <div class="p-3 row row-cols-2 row-cols-lg-5 g-2 g-lg-3" id="category">
        <div class="col">
          <a class="nav-link p-3 border-start border-primary border-4 bg-light" style="border-color: #0064FF;"
             href="main">전체</a>
        </div>
        <div class="col">
          <a class="nav-link p-3 border-start border-primary border-4 bg-light" style="border-color: #0064FF;"
             href="javascript:void(0)" onclick="changeCategory('일반게시판')">일반</a>
        </div>
        <div class="col ">
          <a class="nav-link p-3 border-start border-primary border-4 bg-light" style="border-color: #0064FF;"
             href="javascript:void(0)" onclick="changeCategory('자랑게시판')">자랑</a>
        </div>
        <div class="col ">
          <a class="nav-link p-3 border-start border-primary border-4 bg-light" style="border-color: #0064FF;"
             href="javascript:void(0)" onclick="changeCategory('질문게시판')">질문</a>
        </div>
        <div class="col ">
          <a class="nav-link p-3 border-start border-primary border-4 bg-light" style="border-color: #0064FF;"
             href="javascript:void(0)" onclick="changeCategory('훈련일지')">훈련일지</a>
        </div>
      </div>

      <div class="p-1 col d-flex justify-content-end">
        <div class="form-check form-check-inline">
          <input class="form-check-input" type="radio" name="sort" value="date" onchange="changeSort()"
          ${empty param.sort or param.sort eq 'date' ? 'checked' : ''}>
          <label class="form-check-label">최신순</label>
        </div>
        <div class="form-check-inline">
          <input class="form-check-input" type="radio" name="sort" value="like" onchange="changeSort()"
          ${param.sort eq 'like' ? 'checked' : ''}>
          <label class="form-check-label">추천순</label>
        </div>
        <div class="form-check-inline">
          <input class="form-check-input" type="radio" name="sort" value="viewCnt" onchange="changeSort()"
          ${param.sort eq 'viewCnt' ? 'checked' : ''}>
          <label class="form-check-label">조회순</label>
        </div>
        <div>
          <select class="form-control-sm" name="rows" onchange="changeRows()">
            <option value="5" ${param.rows eq 5 ? 'selected' : ''}>5개씩 보기</option>
            <option value="10" ${empty param.rows or param.rows eq 10 ? 'selected' : ''}>10개씩 보기</option>
            <option value="20" ${param.rows eq 20 ? 'selected' : ''}>20개씩 보기</option>
            <option value="30" ${param.rows eq 30 ? 'selected' : ''}>30개씩 보기</option>
          </select>
        </div>
      </div>

      <!--  게시글 목록 -->
      <div class="row p-3">
        <table class="table">
          <colgroup>
            <col width="5%">
            <col width="10%">
            <col width="*%">
            <col width="15%">
            <col width="10%">
            <col width="10%">
            <col width="10%">
          </colgroup>
          <thead class="text-start">
          <tr style="text-align: center">
            <th>번호</th>
            <th>분류</th>
            <th>제목</th>
            <th>작성자</th>
            <th>추천</th>
            <th>조회</th>
            <th>날짜</th>
          </tr>
          </thead>
          <tbody class="text-start">
          <c:choose>
            <c:when test="${empty boards}">
              <tr>
                <td colspan="7" style="text-align: center">등록된 게시글이 없습니다.</td>
              </tr>
            </c:when>
            <c:otherwise>
              <c:forEach var="board" items="${boards}">
                <tr style="text-align: center">
                  <td>${board.no}</td>
                  <td>${board.catName}</td>
                  <td id="content-title" style="text-align: start">
                    <a href="hit?no=${board.no}" style="text-decoration-line: none; color: black">${board.title}</a>
                    <c:if test="${board.replyCnt gt 0}">
                      <span class="badge rounded-pill text-bg-danger">${board.replyCnt}</span>
                    </c:if>
                  </td>
                  <td>${board.user.nickname}</td>
                  <td>${board.like}</td>
                  <td>${board.viewCnt}</td>
                  <td><fmt:formatDate value="${board.createdDate}" pattern="yyyy-MM-dd"/></td>
                </tr>
              </c:forEach>
            </c:otherwise>
          </c:choose>
          </tbody>
        </table>
      </div>

      <!-- 검색 및 글쓰기 기능 -->
      <div class="row p-3 d-flex justify-content-left">
        <div class="col-2">
          <select class="form-control" name="opt">
            <option value="all" ${param.opt eq 'all' ? 'selected' : ''}> 제목+내용</option>
            <option value="title" ${param.opt eq 'title' ? 'selected' : ''}> 제목</option>
            <option value="content" ${param.opt eq 'content' ? 'selected' : ''}> 내용</option>
            <option value="reply" ${param.opt eq 'reply' ? 'selected' : ''}> 댓글</option>
            <option value="nickname" ${param.opt eq 'nickname' ? 'selected' : ''}> 작성자</option>
          </select>
        </div>
        <div class="col-4">
          <input type="text" class="form-control" name="keyword" value="${param.keyword }">
        </div>
        <div class="col-1">
          <button class="btn btn-outline-primary" onclick="searchKeyword()">검색</button>
        </div>

        <security:authorize access="isAuthenticated()">
          <security:authentication property="principal" var="loginUser"/>
          <div class="col d-flex justify-content-end">
            <c:if test="${not empty loginUser}">
              <a href="form" type="button" class="btn btn-primary">글쓰기</a>
            </c:if>
          </div>
        </security:authorize>
      </div>

      <!-- 페이징처리 -->
      <c:if test="${paging.totalRows ne 0}">
      <div>
        <ul class="pagination justify-content-center">
          <li class="page-item ${paging.first ? 'disabled' : '' }">
            <a class="page-link"
               onclick="changePage(${paging.prevPage}, event)"
               href="javascript:void(0)"><<</a>
          </li>

          <c:forEach var="num" begin="${paging.beginPage }" end="${paging.endPage }">
            <li class="page-item ${paging.page eq num ? 'active' : '' }">
              <a class="page-link"
                 onclick="changePage(${num }, event)"
                 href="javascript:void(0)">${num }</a>
            </li>
          </c:forEach>

          <li class="page-item ${paging.last ? 'disabled' : '' }">
            <a class="page-link"
               onclick="changePage(${paging.nextPage}, event)"
               href="javascript:void(0)">>></a>
          </li>
        </ul>
      </div>
      </c:if>
    </form>
  </div>
</div>
  <%@include file="/WEB-INF/views/common/footer.jsp" %>
</body>
<script type="text/javascript">
    // 페이지 번호 링크를 클릭했을 때 변화
    function changePage(page, event) {
        // 기본 동작을 막음
        event.preventDefault();
        // 페이지 번호 링크를 클릭했다면 해당 페이징 요청
        let form = document.querySelector("#form-search");
        // 페이지 번호 input 요소 선택
        let pageInput = form.querySelector("input[name=page]");
        // 페이지 번호를 원하는 값으로 설정
        pageInput.value = page;
        // 폼 제출
        form.submit();
    }

    // 검색어를 입력하고 검색버튼을 클릭 했을 때
    function searchKeyword() {
        let pageInput = form.querySelector("input[name=page]");
        pageInput.value = 1;
        form.submit();
    }

    // 정렬방식이 변경될 때
    function changeSort() {
        let form = document.querySelector("#form-search");
        let sortInput = document.querySelector("input[name=sort]");
        sortInput.value = 1;
        form.submit();
    }

    // 한 화면에 표기할 행의 갯수가 변경될 때
    function changeRows() {
        // 페이지 갯수를 클릭했다면 해당 페이징 요청
        let form = document.querySelector("#form-search");
        // 페이지 번호 input 요소 선택
        let rowsInput = document.querySelector("input[name=rows]");
        // 새로 요청하는 페이지는 1로 초기화
        let pageInput = form.querySelector("input[name=page]");
        pageInput.value = 1;
        // 폼 제출
        form.submit();
    }

    // 카테고리를 선택했을 때
    function changeCategory(category) {
        let form = document.querySelector("#form-search");
        let catInput = document.querySelector("#categoryInput");
        let pageInput = document.querySelector("input[name=page]");

        catInput.value = category;
        pageInput.value = 1;

        form.submit();
    }
</script>
</html>