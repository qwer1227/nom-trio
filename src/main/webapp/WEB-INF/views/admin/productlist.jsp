<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@include file="/WEB-INF/views/common/tags.jsp" %>
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
          <h1 class="h3 mb-0 text-gray-800">상품</h1>
        </div>
        <!-- 5-10-20개씩 보기 최신순 이름순 -->
        <c:choose>
            <c:when test="${topNo == 10}">
                <div class="row row-cols-2 row-cols-lg-6 g-3">
                    <div class="col">
                        <a class="nav-link text-center text-white bg-primary fw-bold py-2 px-3 rounded"
                           style="background-color: #0064FF; font-size: 0.9rem;" href="product?topNo=10">전체보기</a>
                    </div>
                    <div class="col">
                        <a class="nav-link text-center text-white bg-primary fw-bold py-2 px-3 rounded"
                           style="background-color: #0064FF; font-size: 0.9rem;" href="product?topNo=10&catNo=11">남성 러닝화</a>
                    </div>
                    <div class="col">
                        <a class="nav-link text-center text-white bg-primary fw-bold py-2 px-3 rounded"
                           style="background-color: #0064FF; font-size: 0.9rem;" href="product?topNo=10&catNo=12">남성 상의</a>
                    </div>
                    <div class="col">
                        <a class="nav-link text-center text-white bg-primary fw-bold py-2 px-3 rounded"
                           style="background-color: #0064FF; font-size: 0.9rem;" href="product?topNo=10&catNo=13">남성 하의</a>
                    </div>
                    <div class="col">
                        <a class="nav-link text-center text-white bg-primary fw-bold py-2 px-3 rounded"
                           style="background-color: #0064FF; font-size: 0.9rem;" href="product?topNo=10&catNo=14">남성 아우터</a>
                    </div>
                </div>
            </c:when>
            <c:when test="${topNo == 20}">
                <div class="row row-cols-2 row-cols-lg-6 g-3">
                    <div class="col">
                        <a class="nav-link text-center text-white bg-primary fw-bold py-2 px-3 rounded"
                           style="background-color: #0064FF; font-size: 0.9rem;" href="product?topNo=20">전체보기</a>
                    </div>
                    <div class="col">
                        <a class="nav-link text-center text-white bg-primary fw-bold py-2 px-3 rounded"
                           style="background-color: #0064FF; font-size: 0.9rem;" href="product?topNo=20&catNo=21">여성 러닝화</a>
                    </div>
                    <div class="col">
                        <a class="nav-link text-center text-white bg-primary fw-bold py-2 px-3 rounded"
                           style="background-color: #0064FF; font-size: 0.9rem;" href="product?topNo=20&catNo=22">여성 상의</a>
                    </div>
                    <div class="col">
                        <a class="nav-link text-center text-white bg-primary fw-bold py-2 px-3 rounded"
                           style="background-color: #0064FF; font-size: 0.9rem;" href="product?topNo=20&catNo=23">여성 하의</a>
                    </div>
                    <div class="col">
                        <a class="nav-link text-center text-white bg-primary fw-bold py-2 px-3 rounded"
                           style="background-color: #0064FF; font-size: 0.9rem;" href="product?topNo=20&catNo=24">여성 아우터</a>
                    </div>
                </div>
            </c:when>
            <c:when test="${topNo == 30}">
                <div class="row row-cols-2 row-cols-lg-5 g-3">
                    <div class="col">
                        <a class="nav-link text-center text-white bg-primary fw-bold py-2 px-3 rounded"
                           style="background-color: #0064FF; font-size: 0.9rem;" href="product?topNo=30">전체보기</a>
                    </div>
                    <div class="col">
                        <a class="nav-link text-center text-white bg-primary fw-bold py-2 px-3 rounded"
                           style="background-color: #0064FF; font-size: 0.9rem;" href="product?topNo=30&catNo=31">양말</a>
                    </div>
                    <div class="col">
                        <a class="nav-link text-center text-white bg-primary fw-bold py-2 px-3 rounded"
                           style="background-color: #0064FF; font-size: 0.9rem;" href="product?topNo=30&catNo=32">모자</a>
                    </div>
                </div>
            </c:when>
        </c:choose>
            <div class="row mt-3">
                <div class="col-12">
                    <form id="form-search" method="get" action="/admin/product">
                        <input type="hidden" name="page" />
                        <input type="hidden" name="topNo" value="${topNo}">
                        <input type="hidden" name="catNo" value="${catNo}">
                        <div class="row g-3">
                            <div class="col-2">
                                <select class="form-control" name="rows" onchange="changeRows()">
                                    <option value="6" ${empty param.rows or param.rows eq 6? "selected" : ""}>6개씩 보기</option>
                                    <option value="12" ${param.rows eq 12? "selected" : ""}>12개씩 보기</option>
                                    <option value="18" ${param.rows eq 18? "selected" : ""}>18개씩 보기</option>
                                </select>
                            </div>
                            <div class="col-3 pt-2">
                                <div class="form-check form-check-inline">
                                    <input class="form-check-input"
                                           type="radio"
                                           name="sort"
                                           value="date"
                                           onchange="changeSort()"
                                           ${empty param.sort or param.sort eq 'date' ? 'checked' : ''}
                                    >
                                    <label class="form-check-label" >최신순</label>
                                </div>
                                <div class="form-check form-check-inline">
                                    <input class="form-check-input"
                                           type="radio"
                                           name="sort"
                                           value="name"
                                           onchange="changeSort()"
                                           ${param.sort eq 'name' ? 'checked' : ''}
                                    >
                                    <label class="form-check-label" >이름순</label>
                                </div>
                                <div class="form-check form-check-inline">
                                    <input class="form-check-input"
                                           type="radio"
                                           name="sort"
                                           value="price"
                                           onchange="changeSort()"
                                           ${param.sort eq 'price' ? 'checked' : ''}
                                    >
                                    <label class="form-check-label" >가격순</label>
                                </div>
                            </div>
                            <div class="col-2">
                                <select class="form-control" name="opt">
                                    <option value="name" ${param.opt eq 'name' ? 'selected' : ''} >상품명</option>
                                    <option value="minPrice" ${param.opt eq 'minPrice' ? 'selected' : '' }>최소가격</option>
                                    <option value="maxPrice" ${param.opt eq 'maxPrice' ? 'selected' : '' }>최대가격</option>
                                </select>
                            </div>
                            <div class="col-4 mb-2">
                              <!-- Search -->
                              <%@include file="/WEB-INF/views/admincommon/searchbar.jsp" %>

                            </div>
                        </div>
                    </form>
                </div>
                <div class="container-xxl text-center" id="wrap">
                    <div class="row row-cols-1 row-cols-md-3 g-4 mt-3 mb-5">
                        <c:forEach var="prod"  items="${products }">
                            <div class="col mb-3">
                                <div class="card h-100">
                                    <a class="text-decoration-none" href="product-detail?no=${prod.no}&colorNo=${prod.colorNum}">
                                        <img src="${prod.imgThum}" class="card-img-top" alt="..." style="object-fit: cover;">
                                    </a>
                                    <div class="card-body">
                                        <h5 class="card-title">${prod.name}</h5>
                                        <div class="text-decoration-none" href="detail">
                                            <div>${prod.brand.name}</div>
                                            <div>${prod.category.name}</div>
                                            <div class="card-text"><fmt:formatNumber value="${prod.price }"/> 원</div>
                                        </div>
                                    </div>
                                    <div class="card-footer bg-transparent border-primary" >${prod.status}</div>
                                </div>
                            </div>
                        </c:forEach>
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
                                href="product?page=${paging.prevPage}">이전</a>
                            </li>
                            <c:forEach var="num" begin="${paging.beginPage}" end="${paging.endPage}">
                                <li class="page-item ${paging.page eq num ? 'active' : ''}">
                                    <a class="page-link"
                                    onclick="changePage(${num}, event)"
                                    href="product?page=${num}">${num}</a>
                                </li>
                            </c:forEach>
                            <li class="page-item ${paging.last ? 'disabled' : ''}" >
                                <a class="page-link"
                                onclick="changePage(${paging.nextPage}, event)"
                                href="product?page=${paging.nextPage}">다음</a>
                            </li>
                        </ul>
                    </nav>
                </div>
            </div>

      <!-- end Page Content -->
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
</script>
</html>

