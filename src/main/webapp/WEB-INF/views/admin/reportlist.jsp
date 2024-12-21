<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@include file="/WEB-INF/views/common/tags.jsp" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="java.util.Date" %>
<!DOCTYPE html>
<html lang="en">

<head>

  <meta charset="utf-8">
  <meta http-equiv="X-UA-Compatible" content="IE=edge">
  <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
  <meta name="description" content="">
  <meta name="author" content="">

  <title>SB Admin 2 - Dashboard</title>

  <!-- Custom fonts for this template-->
  <link href="${pageContext.request.contextPath}/resources/vendor/fontawesome-free/css/all.min.css" rel="stylesheet" type="text/css">
  <link
          href="https://fonts.googleapis.com/css?family=Nunito:200,200i,300,300i,400,400i,600,600i,700,700i,800,800i,900,900i"
          rel="stylesheet">
  <!-- Bootstrap CSS 링크 예시 페이지네이션-->
  <link href="https://stackpath.bootstrapcdn.com/bootstrap/5.1.3/css/bootstrap.min.css" rel="stylesheet">
  <!-- Custom styles for this template-->
  <link href="${pageContext.request.contextPath}/resources/css/sb-admin-2.min.css" rel="stylesheet">

</head>

<body id="page-top">

<!-- Page Wrapper -->
<div id="wrapper">

  <!-- Sidebar -->
  <%@include file="/WEB-INF/views/admincommon/sidebar.jsp" %>
  <!-- End of Sidebar -->

  <!-- Content Wrapper -->
  <div id="content-wrapper" class="d-flex flex-column">

    <!-- Main Content -->
    <div id="content">

      <!-- Topbar -->
      <%@include file="/WEB-INF/views/admincommon/topbar.jsp" %>
      <!-- End of Topbar -->

      <!-- Begin Page Content -->
      <div class="container-fluid">
        <!-- Page Heading -->
        <div class="d-sm-flex align-items-center justify-content-between mb-4">
          <h1 class="h3 mb-0 text-gray-800">신고글</h1>
        </div>
        <div class="row mt-3">
          <div class="col-12">
            <form id="form-search" method="get" action="/admin/report">
              <input type="hidden" name="page" value="1"/>
              <input type="hidden" name="rows" value="10"/>
              <div class="row g-3">
                <div class="row col-2 align-items-center pr-2 ">
                  <label for="dateInput" class="col-auto col-form-label">날짜</label>
                  <div class="col">
                    <%
                      // 현재 날짜 가져오기
                      SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
                      String currentDate = sdf.format(new Date()); // 현재 날짜를 "yyyy-MM-dd" 형식으로 변환
                      request.setAttribute("currentDate", currentDate); // request에 currentDate를 설정
                    %>
                    <input
                      type="date"
                      name="day"
                      id="dateInput"
                      value="${param.day != null ? param.day : currentDate}"
                      class="form-control form-control-sm rounded-pill border-gray"
                    />
                  </div>
                </div>
                <div class="col-2 pt-2">
                  <div class="form-check form-check-inline">
                    <input class="form-check-input"
                           type="radio"
                           name="sort"
                           value="latest"
                           onchange="changeSort()"
                    ${empty param.sort or param.sort eq 'latest' ? 'checked' : ''}
                    >
                    <label class="form-check-label" >최신 순</label>
                  </div>
                  <div class="form-check form-check-inline">
                    <input class="form-check-input"
                           type="radio"
                           name="sort"
                           value="oldest"
                           onchange="changeSort()"
                    ${param.sort eq 'oldestDate' ? 'checked' : ''}
                    >
                    <label class="form-check-label" >오래된 순</label>
                  </div>
                </div>
                <div class="col-1">
                  <select class="form-control" name="opt">
                    <option value="all" ${param.opt eq 'all' ? 'selected' : ''}>전체</option>
                    <option value="board" ${param.opt eq 'board' ? 'selected' : '' }>게시글</option>
                    <option value="boardRe" ${param.opt eq 'boardRe' ? 'selected' : '' }>게시글댓글</option>
                    <option value="crew" ${param.opt eq 'crew' ? 'selected' : '' }>크루</option>
                    <option value="crewRe" ${param.opt eq 'crewRe' ? 'selected' : '' }>크루댓글</option>
                  </select>
                </div>
                <div class="col-1">
                  <select class="form-control" name="keyword">
                    <option value="all" ${param.opt eq 'all' ? 'selected' : ''}>전체</option>
                    <option value="name" ${param.opt eq 'name' ? 'selected' : '' }>이름</option>
                    <option value="nickname" ${param.opt eq 'nickname' ? 'selected' : '' }>닉네임</option>
                  </select>
                </div>
                <div class="col-3">
                  <!-- Search -->
                  <%@include file="/WEB-INF/views/admincommon/searchbar.jsp" %>
                  <!-- Search -->
                </div>
              </div>
            </form>
              </div>
          </div>
        </div>
        <div class="row mb-3">
          <div class="col-12">
            <div class="border-bottom pt-4 pr-4 pl-4 bg-light">
              <table class="table border-bottom">
                <colgroup>
                  <col width="7%">
                  <col width="7%">
                  <col width="7%">
                  <col width="13%">
                  <col width="*%">
                  <col width="8%">
                  <col width="8%">
                  <col width="8%">
                </colgroup>
                <thead class="text-center">
                  <tr>
                    <th>신고유형</th>
                    <th>신고번호</th>
                    <th>신고자</th>
                    <th>닉네임</th>
                    <th>신고 사유</th>
                    <th>날짜</th>
                    <th>접수시간</th>
                    <th>처리상태</th>
                    <th>신고</th>
                  </tr>
                </thead>
                <tbody class="text-center">
                  <c:forEach var="d" items="${dto}">
                    <tr>
                      <td>${d.reportType}</td>
                      <td>${d.reportNo}</td>
                      <td>${d.userName}</td>
                      <td>${d.userNickname}</td>
                      <td>${d.reportReason}</td>
                      <td>${d.reportDate}</td>
                      <td>${d.reportTime}</td>
                      <td>${d.isComplete}</td>
                      <td>
                        <form action="/admin/updateReport" method="post">
                            <input type="hidden" name="reportNo" value="${d.reportNo}">
                            <input type="hidden" name="reportType" value="${d.reportType}">
                            <input type="hidden" name="action" value=""> <!-- action 값 추가 -->
                            <button type="button" class="btn btn-google btn-sm" onclick="openReportModal(this)"
                            <c:if test="${d.isComplete == '처리완료'}">disabled </c:if>>
                                신고하기
                            </button>
                        </form>
                      </td>
                    </tr>
                  </c:forEach>
                </tbody>
              </table>
            </div>
          </div>
        </div>
        <!-- 페이징 처리 -->

            <div class="row mb-3">
				<div class="col-12">
                    <nav>
                        <ul class="pagination justify-content-center">
                            <li class="page-item ${paging.first? 'disabled' : ''}">
                                <a class="page-link"
                                onclick="changePage(${paging.prevPage}, event)"
                                href="report?page=${paging.prevPage}">이전</a>
                            </li>
                            <c:forEach var="num" begin="${paging.beginPage}" end="${paging.endPage}">
                                <li class="page-item ${paging.page eq num ? 'active' : ''}">
                                    <a class="page-link"
                                    onclick="changePage(${num}, event)"
                                    href="report?page=${num}">${num}</a>
                                </li>
                            </c:forEach>
                            <li class="page-item ${paging.last ? 'disabled' : ''}" >
                                <a class="page-link"
                                onclick="changePage(${paging.nextPage}, event)"
                                href="report?page=${paging.nextPage}">다음</a>
                            </li>
                        </ul>
                    </nav>
                </div>
            </div>

      </div>
      <!-- end Page Content -->
    </div>
  </div>
</div>
<!-- Modal -->
<div class="modal fade" id="reportModal" tabindex="-1" role="dialog" aria-labelledby="reportModalLabel" aria-hidden="true">
  <div class="modal-dialog" role="document">
    <div class="modal-content">
      <div class="modal-header">
        <h5 class="modal-title" id="reportModalLabel">신고 상태 변경</h5>
      </div>
      <div class="modal-body">
        해당 신고를 승인하시겠습니까?
      </div>
      <div class="modal-body2 mb-2">
        <button type="button" class="btn btn-success ml-2" id="approveReport">승인 (Approve)</button>
        <button type="button" class="btn btn-danger ml-2" id="rejectReport">거부 (Reject)</button>
      </div>
      <div class="modal-footer">
        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">닫기</button>
      </div>
    </div>
  </div>
</div>

<!-- Footer -->
<%@include file="/WEB-INF/views/admincommon/footer.jsp" %>
<!-- End of Footer -->
<%@include file="/WEB-INF/views/admincommon/common.jsp" %>
</body>
<script>
  const form =document.querySelector("#form-search");
  const pageInput = document.querySelector("input[name=page]");

  function changeSort() {
    pageInput.value = 1;
    form.submit();
  }

  // 한 화면에 표시할 행의 갯수가 변경될 때
  function changeRows() {
    pageInput.value = 1;		// 표시할 행의 갯수가 바뀌면 무조건 1페이지 요청
    form.submit();
  }

  // 검색어를 입력하고 검색버튼을 클릭했을 때
  function searchValue() {
    pageInput.value = 1;		// 정렬방식이 바뀌면
    form.submit();
  }

  // 페이지번호 링크를 클릭했을 때
  function changePage(page, event) {
    event.preventDefault();
    pageInput.value = page;	// 페이지번호 링크를 클릭했다면 해당 페이지 요청

    form.submit();
  }
  let currentForm; // 현재 폼을 저장할 변수

  // 신고 모달 열기
  function openReportModal(button) {
    currentForm = button.closest('form'); // 클릭된 버튼의 부모 폼 찾기
    $('#reportModal').modal('show'); // 신고 설정 모달 열기
  }

  // 신고 승인 (Approve)
  document.getElementById('approveReport').addEventListener('click', function() {
    if (currentForm) {
      currentForm.querySelector('input[name="action"]').value = "approve"; // action을 'approve'로 설정
      currentForm.submit(); // 폼 제출
      alert("신고가 승인되었습니다."); // 알림 메시지
    }
    $('#reportModal').modal('hide'); // 모달 닫기
  });

  // 신고 거부 (Reject)
  document.getElementById('rejectReport').addEventListener('click', function () {
    // 신고 거부 버튼 클릭 시 단순히 모달을 닫기만 수행
    alert("신고가 거부되었습니다."); // 알림 메시지
    $('#reportModal').modal('hide'); // 모달 닫기
  });
</script>

</html>


