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
          <h1 class="h3 mb-0 text-gray-800">상품 정산</h1>
        </div>
        <div class="row mt-3">
          <div class="col-12">
            <form id="form-search" method="get" action="/admin/p-settlement">
              <input type="hidden" name="page" />
              <input type="hidden" name="rows" />
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
<%--                <div class="col-1">--%>
<%--                  <select class="form-control" name="dayType" onchange="changeRows()">--%>
<%--                    <option value="day" >일별</option>--%>
<%--                    <option value="month" >월별</option>--%>
<%--                  </select>--%>
<%--                </div>--%>
                <div class="col-3 pt-2">
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
                           value="oldestDate"
                           onchange="changeSort()"
                    ${param.sort eq 'oldestDate' ? 'checked' : ''}
                    >
                    <label class="form-check-label" >오래된 순</label>
                  </div>
                  <div class="form-check form-check-inline">
                    <input class="form-check-input"
                           type="radio"
                           name="sort"
                           value="price"
                           onchange="changeSort()"
                    ${param.sort eq 'price' ? 'checked' : ''}
                    >
                    <label class="form-check-label" >높은가격 순</label>
                  </div>
                </div>
                <div class="col-1">
                  <select class="form-control" name="opt">
                    <option value="all" ${param.opt eq 'all' ? 'selected' : ''}>전체</option>
<%--                    <option value="ready" ${param.opt eq 'ready' ? 'selected' : ''}>결제확정</option>--%>
                    <option value="notReady" ${param.opt eq 'notReady' ? 'selected' : '' }>결제완료</option>
                    <option value="cancel" ${param.opt eq 'cancel' ? 'selected' : '' }>취소</option>
                  </select>
                </div>
                <div class="col-1">
                  <select class="form-control" name="keyword">
                    <option value="all" ${param.keyword eq 'all' ? 'selected' : ''}>선택안함</option>
                    <option value="payName" ${param.keyword eq 'payName' ? 'selected' : ''}>결제자</option>
                    <option value="payId" ${param.keyword eq 'payId' ? 'selected' : ''}>결제자 ID</option>
                  </select>
                </div>
                <div class="col-3">
                  <!-- Search -->
                  <%@include file="/WEB-INF/views/admincommon/searchbar.jsp" %>
                  <!-- Search -->
                </div>
            </form>
                <div class="col">
                  <a class="btn btn-success" href="chart">
                    차트보기
                  </a>
                </div>
              </div>
          </div>
        </div>
        <div class="row mb-3">
          <div class="col-12">
            <div class="border-bottom pt-4 pr-4 pl-4 bg-light">
              <table class="table border-bottom">
                <colgroup>
                  <col width="7%">
                  <col width="8%">
                  <col width="10%">
                  <col width="*%">
                  <col width="10%">
                  <col width="8%">
                  <col width="7%">
                  <col width="10%">
                  <col width="10%">
                </colgroup>
                <thead class="text-center">
                  <tr>
                    <th>결제타입</th>
                    <th>결제자</th>
                    <th>결제자ID</th>
                    <th>상품명</th>
                    <th>총금액</th>
                    <th>결제방법</th>
                    <th>결제상태</th>
                    <th>날짜</th>
                    <th>시간</th>
                  </tr>
                </thead>
                <tbody class="text-center">
                  <c:forEach var="d" items="${dto}">
                    <tr>
                      <td>${d.payType}</td>
                      <td>${d.userName}</td>
                      <td>${d.userId}</td>
                      <td>
                        <a href="javascript:void(0);" onclick="previewProd(${d.orderNo})">
                          ${d.prodName}
                        </a>
                      </td>
                      <td><fmt:formatNumber value="${d.payPrice }"/> 원</td>
                      <td>${d.payMethod}</td>
                      <td>${d.payStatus}</td>
                      <td>
                      ${d.payDate}
                      </td>
                      <td>
                      ${d.payTime}
                      </td>
                    </tr>
                  </c:forEach>
                </tbody>
              </table>
              <div class="row mb-3">
                <div class="col">
                  <div class="border p-2 bg-dark text-white fw-bold">${param.day} | 매출액: <fmt:formatNumber value="${totalPriceSum}"/> 원</div>
                </div>
              </div>
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
                      href="p-settlement?page=${paging.prevPage}">이전</a>
                  </li>
                  <c:forEach var="num" begin="${paging.beginPage}" end="${paging.endPage}">
                      <li class="page-item ${paging.page eq num ? 'active' : ''}">
                          <a class="page-link"
                          onclick="changePage(${num}, event)"
                          href="p-settlement?page=${num}">${num}</a>
                      </li>
                  </c:forEach>
                  <li class="page-item ${paging.last ? 'disabled' : ''}" >
                      <a class="page-link"
                      onclick="changePage(${paging.nextPage}, event)"
                      href="p-settlement?page=${paging.nextPage}">다음</a>
                  </li>
                </ul>
              </nav>
            </div>
          </div>
        <!-- 페이징 처리 끝 -->
      </div>
      <!-- end Page Content -->
    </div>
  </div>
<!-- 모달 창 -->
<div class="modal fade" id="modal-preview-prod" tabindex="-1" aria-labelledby="modal-preview-prod" aria-hidden="true">
  <div class="modal-dialog modal-lg">
    <div class="modal-content">
      <div class="modal-header">
        <h1 class="modal-title fs-5" id="modal-title-preview-prod">주문상품 보기</h1>
      </div>
      <div class="modal-body">
        <table class="table border-bottom" id="table-rev">
          <colgroup>
            <col width="30%">
            <col width="13%">
            <col width="12%">
            <col width="12%">
            <col width="18%">
            <col width="1%">
          </colgroup>
          <thead>
          <tr>
            <th>상품명</th>
            <th>가격</th>
            <th>색상</th>
            <th>사이즈</th>
            <th>수량</th>
            <th></th>
          </tr>
          </thead>
          <tbody>

          </tbody>
        </table>
      </div>
      <div class="modal-body">
        <table class="table" id="table-rev2">
          <thead>
            <col width="30%">
            <col width="30%">
            <col width="30%">
          </thead>
        <tbody style="background: #4d4d59">

        </tbody>
        </table>
      </div>
      <div class="modal-footer">
        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">닫기</button>
      </div>
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

  async function previewProd(orderNo) {
    let response = await fetch("/admin/p-settlement/preview?orderNo=" + orderNo);
    let data = await response.json();

    let rows = "";

    if (data.length === 0) {
      rows = `
      <tr>
        <td colspan="5" class="text-center">상품이 없습니다.</td>
      </tr>
    `;
    } else {
      for (let rev of data) {
        rows += `
        <tr>
            <td><span>\${rev.prodName}</span></td>
            <td><span>\${new Intl.NumberFormat().format(rev.prodPrice)}원</span></td>
            <td><span>\${rev.colorName}</span></td>
            <td><span>\${rev.prodSize}</span></td>
            <td><span>\${rev.orderProdAmount}</span></td>
            <td><span></span></td>
        </tr>
      `;
      }
      let rev2 = data[0];
      let summaryRows =`
          <tr class="bg-dark text-white fw-bold">
              <th>합계 : \${new Intl.NumberFormat().format(rev2.orderPrice)}원</th>
              <th>할인가 : \${new Intl.NumberFormat().format(rev2.orderDisPrice)}원</th>
              <th>결제금액 : \${new Intl.NumberFormat().format(rev2.orderRealPrice)}원</th>
          </tr>
        `;
      document.querySelector("#table-rev2 tbody").innerHTML = summaryRows;
    }
    document.querySelector("#table-rev tbody").innerHTML = rows;


    const myModal = new bootstrap.Modal('#modal-preview-prod');

    myModal.show();
  }

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
</script>

</html>


