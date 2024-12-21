<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ include file="/WEB-INF/views/common/tags.jsp" %>
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
    <link href="${pageContext.request.contextPath}/resources/vendor/fontawesome-free/css/all.min.css" rel="stylesheet"
          type="text/css">
    <link href="https://fonts.googleapis.com/css?family=Nunito:200,200i,300,300i,400,400i,600,600i,700,700i,800,800i,900,900i"
          rel="stylesheet">
    <!-- Bootstrap CSS -->
    <link href="https://stackpath.bootstrapcdn.com/bootstrap/5.1.3/css/bootstrap.min.css" rel="stylesheet">
    <!-- Custom styles for this template-->
    <link href="${pageContext.request.contextPath}/resources/css/sb-admin-2.min.css" rel="stylesheet">
</head>

<body id="page-top">

<!-- Page Wrapper -->
<div id="wrapper">

    <!-- Sidebar -->
    <%@ include file="/WEB-INF/views/admincommon/sidebar.jsp" %>
    <!-- End of Sidebar -->

    <!-- Content Wrapper -->
    <div id="content-wrapper" class="d-flex flex-column">

        <!-- Main Content -->
        <div id="content">

            <!-- Topbar -->
            <%@ include file="/WEB-INF/views/admincommon/topbar.jsp" %>
            <!-- End of Topbar -->

            <!-- Begin Page Content -->
            <div class="container-fluid">
                <!-- Page Heading -->
                <div class="d-sm-flex align-items-center justify-content-between mb-4">
                    <h1 class="h3 mb-0 text-gray-800">1:1 문의사항</h1>
                </div>

                <!-- QnA List -->
                <div class="card shadow mb-4">
                    <div class="card-header py-3">
                        <h6 class="m-0 font-weight-bold text-primary">문의사항 목록</h6>
                    </div>
                    <div class="card-body">
                        <div class="table-responsive">
                            <table class="table table-bordered" id="dataTable" width="100%" cellspacing="0">
                                <thead>
                                <tr>
                                    <th>번호</th>
                                    <th>제목</th>
                                    <th>작성자</th>
                                    <th>작성일</th>
                                    <th>상태</th>
                                    <th>카테고리</th>
                                    <th>관리</th>
                                </tr>
                                </thead>
                                <tbody>
                                <c:forEach var="qna" items="${qnaList}">
                                    <tr>
                                        <td>${qna.qnaNo}</td>
                                        <td><a href="/admin/qna/${qna.qnaNo}">${qna.qnaTitle}</a></td>
                                        <td>${qna.user.nickname}</td>
                                        <td><fmt:formatDate value="${qna.qnaCreatedDate}"/></td>
                                        <td>${qna.qnaStatus}</td>
                                        <td>${qna.qnaCategory.categoryName}</td>
                                        <td>
                                            <!-- 삭제 버튼 -->
                                            <form action="/mypage/qna/delete/${qna.qnaNo}" method="post" style="display:inline;" onsubmit="return confirm('정말 삭제하시겠습니까?')">
                                                <button type="submit" class="btn btn-sm btn-danger">삭제</button>

                                            </form>
                                        </td>
                                    </tr>
                                </c:forEach>
                                </tbody>
                            </table>
                        </div>

                        <!-- Pagination -->
                        <nav aria-label="Page navigation example">
                            <ul class="pagination justify-content-center">

                                <!-- "이전" 버튼 -->
                                <c:if test="${pagination.first}">
                                    <li class="page-item disabled">
                                        <a class="page-link" href="#" aria-label="Previous">
                                            <span aria-hidden="true">&laquo;</span>
                                        </a>
                                    </li>
                                </c:if>
                                <c:if test="${!pagination.first}">
                                    <li class="page-item">
                                        <a class="page-link"
                                           href="?page=${pagination.prevPage}&opt=${param.opt}&keyword=${param.keyword}"
                                           aria-label="Previous">
                                            <span aria-hidden="true">&laquo;</span>
                                        </a>
                                    </li>
                                </c:if>

                                <!-- 페이지 번호 -->
                                <c:forEach var="pageNum" begin="${pagination.beginPage}" end="${pagination.endPage}">
                                    <li class="page-item ${pageNum == pagination.page ? 'active' : ''}">
                                        <a class="page-link"
                                           href="?page=${pageNum}&opt=${param.opt}&keyword=${param.keyword}">
                                           ${pageNum}
                                        </a>
                                    </li>
                                </c:forEach>

                                <!-- "다음" 버튼 -->
                                <c:if test="${pagination.last}">
                                    <li class="page-item disabled">
                                        <a class="page-link" href="#" aria-label="Next">
                                            <span aria-hidden="true">&raquo;</span>
                                        </a>
                                    </li>
                                </c:if>
                                <c:if test="${!pagination.last}">
                                    <li class="page-item">
                                        <a class="page-link"
                                           href="?page=${pagination.nextPage}&opt=${param.opt}&keyword=${param.keyword}"
                                           aria-label="Next">
                                            <span aria-hidden="true">&raquo;</span>
                                        </a>
                                    </li>
                                </c:if>

                            </ul>
                        </nav>


                        <!-- Search Form -->
                        <div class="card mb-4">
                            <div class="card-header py-3">
                                <h6 class="m-0 font-weight-bold text-primary">검색 조건</h6>
                            </div>
                            <div class="card-body">
                                <form action="/admin/qna" method="get" class="row g-3">
                                        <div class="col-3 md-4">
                                            <label for="opt" class="form-label">검색 조건</label>
                                            <select class="form-control col-6" id="opt" name="opt">
                                                <option value="title" ${param.opt == 'title' ? 'selected' : ''}>제목</option>
                                                <option value="writer" ${param.opt == 'writer' ? 'selected' : ''}>작성자</option>
                                                <option value="status" ${param.opt == 'status' ? 'selected' : ''}>상태</option>
                                                <option value="category" ${param.opt == 'categoty' ? 'selected' : ''}>카테고리</option>
                                            </select>
                                        </div>
                                        <div class="col-md-4">
                                            <label for="keyword" class="form-label">검색 값</label>
                                            <input type="text" class="form-control" id="keyword" name="keyword"
                                                   value="${param.keyword}">
                                        </div>
                                        <div class="col-md-4 align-self-end">
                                            <button type="submit" class="btn btn-primary w-10">검색</button>
                                        </div>
                                </form>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Footer -->
            <%@ include file="/WEB-INF/views/admincommon/footer.jsp" %>
            <!-- End of Footer -->

        </div>
    </div>

    <%@ include file="/WEB-INF/views/admincommon/common.jsp" %>

</body>
</html>
