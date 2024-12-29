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

    <style>
        /* 배송준비중 */
        .status-ready {
            color: #007bff;  /* 파란색 */
            font-weight: bold;
        }

        /* 배송출발 */
        .status-shipped {
            color: #ffc107;  /* 노란색 */
            font-weight: bold;
        }

        /* 배송완료 */
        .status-delivered {
            color: #28a745;  /* 초록색 */
            font-weight: bold;
        }

        /* 배송취소 */
        .status-cancel {
            color: #cd0c0c;  /* 빨간색 */
            font-weight: bold;
        }
        .status-wait {
            color: #000000;  /* 검은색 */
            font-weight: bold;
        }
    </style>
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
                    <h1 class="h3 mb-0 text-gray-800">주문&배송 조회</h1>
                </div>
                <div class="row mt-3">
                    <div class="col-12">
                        <form id="form-search" method="get" action="/admin/order-delivery">
                            <input type="hidden" name="page" value="1" />
                            <input type="hidden" name="rows" value="10" />
                            <div class="row g-3">
                                <div class="row col-2 align-items-center pr-2">
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
                                <div class="col-2 ml-3 pt-2">
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
                                </div>
                                <div class="col-2">
                                    <select class="form-control" name="opt">
                                        <option value="all" ${param.opt eq 'all' ? 'selected' : ''}>주문상태</option>
                                        <option value="notReady" ${param.opt eq 'notReady' ? 'selected' : '' }>상품준비중</option>
                                        <option value="ready" ${param.opt eq 'ready' ? 'selected' : '' }>상품배송중</option>
                                        <option value="complete" ${param.opt eq 'complete' ? 'selected' : '' }>상품배송완료</option>
                                        <option value="cancel" ${param.opt eq 'cancel' ? 'selected' : '' }>주문취소</option>
                                    </select>
                                </div>
                                <div class="col-1">
                                    <select class="form-control" name="keyword">
                                        <option value="all" ${param.keyword eq 'all' ? 'selected' : ''}>선택안함</option>
                                        <option value="orderName" ${param.keyword eq 'orderName' ? 'selected' : ''}>수령인</option>
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
                <div class="row mb-3">
                  <div class="col-12">
                    <div class="border-bottom pt-4 pr-4 pl-4 bg-light">
                      <table class="table">
                        <colgroup>
                          <col width="6%">
                          <col width="6%">
                          <col width="20%">
                          <col width="8%">
                          <col width="8%">
                          <col width="7%">
                          <col width="8%">
                          <col width="10%">
                          <col width="8%">
                          <col width="7%">
                        </colgroup>
                        <thead>
                          <tr>
                            <th>배송번호</th>
                            <th>업체</th>
                            <th>주문번호</th>
                            <th>수령인</th>
                            <th>주문상태</th>
                            <th>배송비</th>
                            <th>배송상태</th>
                            <th>주문날짜</th>
                            <th>결제상태</th>
                            <th>배송변경</th>
                          </tr>
                        </thead>
                        <tbody>
                          <c:forEach var="d" items="${dto}">
                            <tr>
                              <td>${d.deliNo}</td>
                              <td>${d.deliCom}</td>
                              <td>${d.orderNumber}</td>
                              <td>${d.addrName}</td>
                              <td>
                                  ${d.orderStatus}
                              </td>
                              <td><fmt:formatNumber value="${d.deliPay }"/> 원</td>
                              <td>
                                <c:choose>
                                    <c:when test="${d.deliStatus == '배송준비중'}">
                                        <span class="status-ready">${d.deliStatus}</span>  <!-- 배송준비중 -->
                                    </c:when>
                                    <c:when test="${d.deliStatus == '배송출발'}">
                                        <span class="status-shipped">${d.deliStatus}</span>  <!-- 배송출발 -->
                                    </c:when>
                                    <c:when test="${d.deliStatus == '배송완료'}">
                                        <span class="status-delivered">${d.deliStatus}</span>  <!-- 배송완료 -->
                                    </c:when>
                                    <c:when test="${d.deliStatus == '배송취소'}">
                                        <span class="status-cancel">${d.deliStatus}</span>  <!-- 배송완료 -->
                                    </c:when>
                                    <c:when test="${d.deliStatus == '대기중'}">
                                        <span class="status-wait">${d.deliStatus}</span>  <!-- 배송완료 -->
                                    </c:when>
                                    <c:otherwise>
                                        <span>${d.deliStatus}</span>  <!-- 기타 상태 -->
                                    </c:otherwise>
                                </c:choose>
                              </td>
                              <td>
                              ${d.orderDate}
                              </td>
                              <td>
                              ${d.payStatus}
                              </td>
                              <td>
                                <form action="/admin/updateDeliveryStatus" method="post">
                                    <input type="hidden" name="page" value="${param.page}">
                                    <input type="hidden" name="rows" value="${param.rows}">
                                    <input type="hidden" name="day" value="${param.day}">
                                    <input type="hidden" name="deliNo" value="${d.deliNo}">
                                    <input type="hidden" name="deliStatus" value="${d.deliStatus}">
                                    <!-- 기타 폼 필드들 -->
                                    <button type="button" class="btn btn-sm btn-facebook"
                                    onclick="openDeliveryModal(this)"
                                    <c:if test="${d.deliStatus == '배송취소'}"> disabled </c:if>>상태 변경</button>
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
                      href="order-delivery?page=${paging.prevPage}">이전</a>
                  </li>
                  <c:forEach var="num" begin="${paging.beginPage}" end="${paging.endPage}">
                      <li class="page-item ${paging.page eq num ? 'active' : ''}">
                          <a class="page-link"
                          onclick="changePage(${num}, event)"
                          href="order-delivery?page=${num}">${num}</a>
                      </li>
                  </c:forEach>
                  <li class="page-item ${paging.last ? 'disabled' : ''}" >
                      <a class="page-link"
                      onclick="changePage(${paging.nextPage}, event)"
                      href="order-delivery?page=${paging.nextPage}">다음</a>
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
</div>
<!-- Modal -->
<div class="modal fade" id="showModal" tabindex="-1" role="dialog" aria-labelledby="showModalLabel" aria-hidden="true">
    <div class="modal-dialog" role="document">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title" id="showModalLabel">배송 상태 변경</h5>
            </div>
            <div class="modal-body">
                배송 상태를 변경하시겠습니까?
                <!-- 버튼 3개: 배송준비중, 배송출발, 배송완료 -->
                <div class="row mt-2">
                    <button type="button" class="btn btn-primary ml-2" id="setReady">배송준비중</button>
                    <button type="button" class="btn btn-warning ml-2" id="setShipped">배송출발</button>
                    <button type="button" class="btn btn-success ml-2" id="setDelivered">배송완료</button>
                </div>
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

    let currentForm;  // 현재 선택된 폼을 저장할 변수

    // 배송 상태 변경 모달 열기
    function openDeliveryModal(button) {
        currentForm = button.closest('form');  // 클릭한 버튼의 부모 폼을 찾음
        $('#showModal').modal('show');  // 배송 상태 변경 모달을 열기
    }

    function changeDeliveryStatus(status) {
        if (currentForm) {
            currentForm.querySelector('input[name="deliStatus"]').value = status;  // 배송 상태 값 설정
            currentForm.submit();  // 폼 전송
            alert("상태가 변경되었습니다.");  // 상태 변경 알림 창 표시
        }
        $('#showModal').modal('hide');  // 모달 닫기
    }

    // 배송 상태를 '배송준비중'으로 설정
    document.getElementById('setReady').addEventListener('click', function() {
        changeDeliveryStatus("배송준비중");
    });

    // 배송 상태를 '배송출발'로 설정
    document.getElementById('setShipped').addEventListener('click', function() {
        changeDeliveryStatus("배송출발");
    });

    // 배송 상태를 '배송완료'로 설정
    document.getElementById('setDelivered').addEventListener('click', function() {
        changeDeliveryStatus("배송완료");
    });

</script>
</html>

