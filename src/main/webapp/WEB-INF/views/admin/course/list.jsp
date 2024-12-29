<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@include file="/WEB-INF/views/common/tags.jsp" %>
<c:set var="s3" value="https://2404-bucket-team-1.s3.ap-northeast-2.amazonaws.com" />
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
        .card img {
            height: 250px; /* 모든 이미지가 같은 높이가 되도록 설정 */
        }
    /* 거리 슬라이더 스타일 */
    .form-range {

        height: 8px;
        border-radius: 5px;
    }
    .form-range::-webkit-slider-thumb {
        background-color: #0064FF;
        border: none;
        height: 16px;
        width: 16px;
        border-radius: 50%;
    }
    .form-range::-moz-range-thumb {
        background-color: #0064FF;
        border: none;
        height: 16px;
        width: 16px;
        border-radius: 50%;
    }

    /* 버튼 스타일 */
    .btn-outline-primary {

        background-color: transparent;
    }



    /* 슬라이더 값 표시 */
    .row .col {
        font-size: 12px;
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
          <h1 class="h3 mb-0 text-gray-800">코스</h1>
        </div>
        <!-- 5-10-20개씩 보기 최신순 이름순 -->
        <div class="row row-cols-1 row-cols-md-1 g-4 mt-3 mb-3">
        <div class="col">
            <form id="form-search" method="get" action="/admin/course">
                <input type="hidden" name="page"/>
                <div class="row g-3 d-flex justify-content-center">
                    <!-- 추천순 -->
                    <div class="row col-1 text-start">
                        <label for="customRange2" class="col-8 form-label text-end pt-3 mt-2">추천순</label>
                        <input type="checkbox" class="col-2 form-check mt-1" name="sort" value="like" ${param.sort eq 'like' ? 'checked' : ''}>
                    </div>
                    <!-- 거리 슬라이더 -->
                    <div class="col-4">
                        <label for="customRange2" class="form-label">거리</label>
                        <input type="range" class="form-range" min="0" max="10" id="customRange2" name="distance"
                            value="${empty param.distance ? '10' : param.distance}" style="accent-color: #0064FF; width: 100%;"/>
                        <div class="row text-center">
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
                    <!-- 난이도 -->
                    <div class="col-1">
                        <label for="level">난이도</label>
                        <select class="form-control form-select" name="level">
                            <option value="">전체</option>
                            <c:forEach var="num" begin="1" end="5">
                                <option value="${num}" ${param.level eq num ? "selected" : ""}>${num}단계</option>
                            </c:forEach>
                        </select>
                    </div>
                    <!-- 지역 검색 -->
                    <div class="col-1">
                        지역
                        <select class="form-control mt-2" name="region" style="appearance: auto;">
                            <option value="si" ${param.region eq 'si' ? 'selected' : ''}>시</option>
                            <option value="gu" ${param.region eq 'gu' ? 'selected' : ''}>구</option>
                            <option value="dong" ${param.region eq 'dong' ? 'selected' : ''}>동</option>
                        </select>
                    </div>
                    <div class="col-2">
                        <label for="keyword">지역 검색</label>
                        <input type="text" class="form-control" name="keyword" value="${param.keyword}">
                    </div>
                    <!-- 검색 버튼 -->
                    <div class="col-1 pt-4">
                        <button type="button" class="btn btn-outline-primary" onclick="searchKeyword()">검색</button>
                    </div>
                </div>
            </form>
        </div>
    </div>

        <div class="container-xxl text-center" id="wrap">
          <div class="row row-cols-1 row-cols-md-4 g-4 mt-5 mb-5">
        <c:forEach var="course" items="${courses }">
            <div class="col-3 mb-3">
                <div class="card h-100">
                    <a class="text-decoration-none" href="course-detail?no=${course.no }">
                        <div class="main_image" style="position: relative;">
                            <img src="${s3}/resources/images/course/${course.filename }" class="card-img-top" alt="..."
                                 width="200" height="200">
                        </div>
                    </a>
                    <div class="card-body">
                        <h5 class="card-title">${course.name }</h5>
                        <a class="text-decoration-none" href="course-detail?no=${course.no }">
                            <p class="card-text">${course.region.si } ${course.region.gu } ${course.region.dong }</p>
                        </a>
                    </div>
                    <div class="card-footer bg-transparent border-primary" >
                        <span class="badge rounded-pill text-bg-dark">난이도 ${course.level }단계</span>
                        <span class="badge rounded-pill text-bg-dark">거리 ${course.distance }KM</span>
                        <span class="badge rounded-pill text-bg-danger">♡ ${course.likeCnt }개</span>
                    </div>
                </div>
            </div>
        </c:forEach>
    </div>
        </div>
      </div>
      <!-- 페이징처리 -->
        <c:if test="${not empty courses}">
            <div class="row mb-3">
				<div class="col-12">
					<nav>
						<ul class="pagination justify-content-center">
						    <li class="page-item ${paging.first ? 'disabled' : '' }">
						    	<a class="page-link"
						    		onclick="changePage(${paging.prevPage}, event)"
						    		href="course?page=${paging.prevPage}">이전</a>
						    </li>
						<c:forEach var="num" begin="${paging.beginPage }" end="${paging.endPage }">
						    <li class="page-item ${paging.page eq num ? 'active' : '' }">
						    	<a class="page-link"
						    		onclick="changePage(${num }, event)"
						    		href="course?page=${num }">${num }</a>
						    </li>
						</c:forEach>
						    <li class="page-item ${paging.last ? 'disabled' : '' }">
						    	<a class="page-link"
						    		onclick="changePage(${paging.nextPage}, event)"
						    		href="course?page=${paging.nextPage}">다음</a>
						    </li>
					  	</ul>
					</nav>
				</div>
			</div>
        </c:if>
    <!-- 페이징처리 끝 -->
      <!-- end Page Content -->
    </div>
  </div>
</div>
<!-- Footer -->
<%@include file="/WEB-INF/views/admincommon/footer.jsp" %>
<!-- End of Footer -->

<%@include file="/WEB-INF/views/admincommon/common.jsp" %>
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

  // 검색 버튼을 클릭했을 때, 요청 파라미터 정보를 제출한다.
  function searchKeyword() {
      pageInput.value = 1;
      form.submit();
  }
</script>
</body>

</html>

