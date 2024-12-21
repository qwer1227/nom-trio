<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@include file="/WEB-INF/views/common/tags.jsp" %>
<!doctype html>
<html lang="ko">
<head>
  <script src="https://code.jquery.com/jquery-3.6.4.min.js"></script>
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

  <!-- 게시글 정렬 기능 -->
  <form id="form-search" method="get" action="history">
    <input type="hidden" name="page" value="${param.page != null ? param.page : 1}">
    <input type="hidden" name="category" id="categoryInput" value="${param.category }">

    <div class="p-1 col d-flex justify-content-between">
      <!-- 왼쪽 끝단 버튼 영역 -->
      <div>
        <input type="hidden" name="type" id="typeInput" value="${empty param.type ? 'value1' : param.type}">
        <button type="button" class="btn ${empty param.type or param.type eq 'value1' ? 'btn-outline-primary' : 'btn-outline-secondary'} me-2" id="btnValue1" >내가 쓴 글 보기</button>
        <button type="button"  class="btn ${param.type eq 'value2' ? 'btn-outline-primary' : 'btn-outline-secondary'}" id="btnValue2" >내가 쓴 댓글 보기</button>
      </div>

      <!-- 오른쪽 끝단 검색 옵션 영역 -->
      <div class="d-flex justify-content-end">
        <div class="form-check form-check-inline">
          <input class="form-check-input" type="radio" name="sort" value="date" onchange="changeSort()"
          ${empty param.sort or param.sort eq 'date' ? 'checked' : ''}>
          <label class="form-check-label">최신순</label>
        </div>
        <div class="form-check form-check-inline">
          <input class="form-check-input" type="radio" name="sort" value="like" onchange="changeSort()"
          ${param.sort eq 'like' ? 'checked' : ''}>
          <label class="form-check-label">추천순</label>
        </div>
        <div class="form-check form-check-inline">
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
                  <a href="/community/board/detail?no=${board.no}" style="text-decoration-line: none; color: black">${board.title}</a>
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
          <option value="title" ${param.opt eq 'title' ? 'selected' : ''}> 게시글 제목</option>
          <option value="content" ${param.opt eq 'content' ? 'selected' : ''}> 게시글 내용</option>
          <option value="writer" ${param.opt eq 'writer' ? 'selected' : ''}> 작성자</option>
          <%--        <option value="hashtag"> 해시태그</option>--%>
        </select>
      </div>

      <div class="col-2">
        <input type="text" class="form-control" name="keyword" value="${param.keyword }">
      </div>
      <div class="col-1">
        <button type="button" class="btn btn-outline-primary" onclick="searchKeyword()">검색</button>
      </div>
      <div class="col d-flex justify-content-center">

      </div>
      <div class="col d-flex justify-content-end">
        <a href="form" type="button" class="btn btn-primary">글쓰기</a>
      </div>
    </div>

    <!-- 페이징처리 -->
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
  </form>
</div>
<%@include file="/WEB-INF/views/common/footer.jsp" %>
</body>
<script type="text/javascript">

  let form = document.querySelector("#form-search");
  let pageInput = document.querySelector("input[name=page]");
  let catInput = document.querySelector("#categoryInput");

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
    function searchValue() {

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
        pageInput.value = 1;
        // 폼 제출
        form.submit();
    }

    // 카테고리를 선택했을 때
    function changeCategory(category) {
        catInput.value = category;
        pageInput.value = 1;
        form.submit();
    }

    function searchKeyword() {
      pageInput.value = 1;
      form.submit();
    }

    $("#btnValue1").click(function () {
      $("input[name=type]").val("value1");
      pageInput.value = 1;
      form.submit();
    })

    $("#btnValue2").click(function () {
      $("input[name=type]").val("value2");
      pageInput.value = 1;
      form.submit();
    })
</script>
</html>