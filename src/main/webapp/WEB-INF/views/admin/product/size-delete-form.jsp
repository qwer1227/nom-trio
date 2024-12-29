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
                    <h1 class="h3 mb-0 text-gray-800">기존 상품 사이즈 삭제</h1>
                </div>
                <div class="container my-3">
                    <div class="row mb-3">
                        <div class="col-6">
                            <div class="border p-2 bg-dark text-white fw-bold">사이즈 삭제</div>
                        </div>
                    </div>
                    <div class="row mb-3">
                        <div class="col-6">
                            <form id="getForm" class="border bg-light p-3"
                                  method="get" action="/admin/delete-size"
                                  enctype="multipart/form-data">
                                <div class="form-group mb-3 col-4">
                                    <input type="hidden" name="no" value="${param.no}">
                                    <input type="hidden" name="colorNo" value="${param.colorNo}">
                                    <label class="form-label">상품번호: ${param.no}</label>
                                </div>
                                <div class="form-group mb-3 col">
                                    <label class="form-label">상품명: ${product.name}</label>
                                </div>
                                <div class="col form-group mb-3 col-4">
                                    <label class="form-label">색상: ${color.name}</label>
                                </div>
                              <div class="form-group mb-3 col-6">
                                    <label class="form-label">기존 등록된 사이즈 :</label>
                                     <div>
                                        <c:choose>
                                            <c:when test="${not empty sizes}">
                                                <ul>
                                                    <c:forEach var="size" items="${sizes}">
                                                        <li>${size.size} (수량: ${size.amount})</li>
                                                    </c:forEach>
                                                </ul>
                                            </c:when>
                                            <c:otherwise>
                                                <p> ${sizeMessage}</p>
                                            </c:otherwise>
                                        </c:choose>
                                    </div>
                                </div>
                                <div class="row justify-content-end">
                                    <div class="text-end" style="text-align: right">
                                        <a type="button" class="btn btn-success mr-2" href="/admin/product-detail?no=${param.no}&colorNo=${param.colorNo}">뒤로가기</a>
                                    </div>
                                    <div class="text-end" style="text-align: right">
                                        <button type="button" id="getSubmitButton" class="btn btn-primary mr-1">조회</button>
                                    </div>
                                </div>
                            </form>

                            <form id="postForm" class="border bg-light p-3" method="post" action="/admin/delete-size" enctype="multipart/form-data" style="display: none;">
                                <input type="hidden" name="no" value="${param.no}">
                                <input type="hidden" name="colorNo" value="${param.colorNo}"/>
                                <div id="imageContainer">
                                    <label class="form-label mb-3 mr-2">사이즈</label>
                                    <c:forEach var="s" items="${sizes}">
                                        <div class="form-group col mb-3">
                                            <label class="form-label mb-3 mr-2">${s.size}</label>
                                            <input type="radio" class="form-check-input ml-2 " name="sizeNo" value="${s.no}" /><br>
                                            <label class="form-label mb-3 mr-2">수량 : ${s.amount}</label>
                                        </div>
                                    </c:forEach>
                                </div>
                                <div class="text-end" style="text-align: right">
                                    <button type="submit" class="btn btn-primary">삭제</button>
                                </div>
                            </form>

                        </div>
                    </div>
                </div>
            </div>
            <!-- end Page Content -->
        </div>
    </div>
</div>
<!-- Footer -->
<%@include file="/WEB-INF/views/admincommon/footer.jsp" %>
<!-- End of Footer -->

<%@include file="/WEB-INF/views/admincommon/common.jsp" %>
<script>
  document.addEventListener("DOMContentLoaded", function () {
    const getSubmitButton = document.getElementById("getSubmitButton");
    const postForm = document.getElementById("postForm");

    // 조회 버튼 클릭 이벤트
    getSubmitButton.addEventListener("click", function () {
      // POST Form 보이기
      postForm.style.display = "block";
    });
  });

</script>
</body>

</html>



