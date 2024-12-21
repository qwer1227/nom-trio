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
<header>
    <c:set var="menu" value="users" />
</header>
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
                    <h1 class="h3 mb-0 text-gray-800">회원</h1>
                </div>
                <!-- 5-10-20개씩 보기 최신순 이름순 -->
                <form id="form-search" method="get" action="/admin/user">
                    <input type="hidden" name="page" />
                    <div class="row g-3 d-flex">
                        <div class="col-2 mb-4 pt-2">
                            <select class="form-control" name="rows" onchange="changeRows()">
                                <option value="5" ${param.rows eq 5 ? "selected" : ""}>5개씩 보기</option>
                                <option value="10" ${empty param.rows or param.rows eq 10 ? "selected" : ""}>10개씩 보기</option>
                                <option value="20" ${param.rows eq 20 ? "selected" : ""}>20개씩 보기</option>
                            </select>
                        </div>
                        <div class="col-2 mb-4 pt-2">
                            <select class="form-control" name="opt">
                                <option value="id" ${param.opt eq 'id' ? 'selected' : ''}>아이디</option>
                                <option value="name" ${param.opt eq 'name' ? 'selected' : ''}>이름</option>
                                <option value="email" ${param.opt eq 'email' ? 'selected' : ''}>이메일</option>
                            </select>
                        </div>
                        <div class="col-4 pt-2" >
                            <!-- Search -->
                            <%@include file="/WEB-INF/views/admincommon/searchbar.jsp" %>
                        </div>
                    </div>
                </form>
                <!-- 5-10-20개씩 보기 최신순 이름순 끝 -->
            </div>
            <!-- 회원 리스트 -->
            <div class="row mb-3">
                <div class="col">
                    <div class="border-bottom pt-4 pr-4 pl-4 bg-light">
                        <table class="table">
                            <colgroup>
                                <col width="7%">
                                <col width="10%">
                                <col width="13%">
                                <col width="10%">
                                <col width="20%">
                                <col width="10%">
                            </colgroup>
                            <thead class="text-center">
                                <tr>
                                    <th>회원번호</th>
                                    <th>이름</th>
                                    <th>아이디</th>
                                    <th>닉네임</th>
                                    <th>이메일</th>
                                    <th>보기</th>
                                </tr>
                            </thead>
                            <tbody class="text-center">
                                <c:forEach var="u" items="${users }">
                                    <tr>
                                        <td>${u.no}</td>
                                        <td>${u.name}</td>
                                        <td>${u.id}</td>
                                        <td>${u.nickname}</td>
                                        <td>${u.email}</td>
                                        <td>
                                            <button class="btn btn-outline btn-success btn-sm"
                                                    onclick="previewUser(${u.no})">미리보기</button>
                                        </td>
                                    </tr>
                                </c:forEach>
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>

            <!-- 페이징처리 -->
        <c:if test="${not empty users}">
            <div class="row mb-3">
				<div class="col-12">
					<nav>
						<ul class="pagination justify-content-center">
						    <li class="page-item ${paging.first ? 'disabled' : '' }">
						    	<a class="page-link"
						    		onclick="changePage(${paging.prevPage}, event)"
						    		href="user?page=${paging.prevPage}">이전</a>
						    </li>
						<c:forEach var="num" begin="${paging.beginPage }" end="${paging.endPage }">
						    <li class="page-item ${paging.page eq num ? 'active' : '' }">
						    	<a class="page-link"
						    		onclick="changePage(${num }, event)"
						    		href="user?page=${num }">${num }</a>
						    </li>
						</c:forEach>
						    <li class="page-item ${paging.last ? 'disabled' : '' }">
						    	<a class="page-link"
						    		onclick="changePage(${paging.nextPage}, event)"
						    		href="user?page=${paging.nextPage}">다음</a>
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

    <!-- 모달 창 -->
    <div class="modal fade" id="modal-preview-user" tabindex="-1" aria-labelledby="modal-title-preview-user" aria-hidden="true">
        <div class="modal-dialog modal-lg">
            <div class="modal-content">
                <div class="modal-header">
                    <h1 class="modal-title fs-5" id="modal-title-preview-user">회원정보 미리보기</h1>
                </div>
                <div class="modal-body">
                    <table class="table">
                        <colgroup>
                            <col width="15%">
                            <col width="35%">
                            <col width="15%">
                            <col width="35%">
                        </colgroup>
                        <tr>
                            <th>번호</th>
                            <td><span id="u-no"></span></td>
                            <th>이름</th>
                            <td><span id="u-name"></span></td>
                        </tr>
                        <tr>
                            <th>아이디</th>
                            <td><span id="u-id"></span></td>
                            <th>닉네임</th>
                            <td><span id="u-nickname"></span></td>
                        </tr>
                        <tr>
                            <th>이메일</th>
                            <td><span id="u-email"></span></td>
                            <th>전화번호</th>
                            <td><span id="u-tel"></span></td>
                        </tr>
                    </table>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">닫기</button>
                </div>
            </div>

        </div>


    </div>
    <!-- 모달 창 끝 -->

    <!-- Footer -->
    <%@include file="/WEB-INF/views/admincommon/footer.jsp" %>
    <!-- End of Footer -->

    <%@include file="/WEB-INF/views/admincommon/common.jsp" %>

<script type="text/javascript">
    const form =document.querySelector("#form-search");
    const pageInput = document.querySelector("input[name=page]");
    const myModal = new bootstrap.Modal('#modal-preview-user');

    async function userForm(userNo) {
        let response = await fetch("/admin/user/form?no=" + userNo);
        let data = await response.json();
    }

     async function previewUser(userNo) {
         let response = await fetch("/admin/user/preview?no=" + userNo);
         let data = await response.json();

         document.getElementById("u-no").textContent = data.no;
         document.getElementById("u-name").textContent = data.name;
         document.getElementById("u-id").textContent = data.id;
         document.getElementById("u-nickname").textContent = data.nickname;
         document.getElementById("u-email").textContent = data.email;
         document.getElementById("u-tel").textContent = data.tel;


         myModal.show();
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

</body>

</html>


