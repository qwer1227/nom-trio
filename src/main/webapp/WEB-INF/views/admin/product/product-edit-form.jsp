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
                    <h1 class="h3 mb-0 text-gray-800">기존 상품 수정</h1>
                </div>
                <div class="container my-3">
                    <div class="row mb-3">
                        <div class="col-6">
                            <div class="border p-2 bg-dark text-white fw-bold">상품 수정</div>
                        </div>
                    </div>
                    <div class="row mb-3">
                        <div class="col-6">
                            <form class="border bg-light p-3"
                                  method="post" action="/admin/register-editform"
                                  enctype="multipart/form-data">
                                <div class="form-group mb-3 col-4">
                                    <label class="form-label">상품번호</label>
                                    <input type="text" class="form-control" name="no" value="${product.no}">
                                </div>
                                <div class="form-group mb-3 col-3">
                                    <label class="form-label">카테고리</label>
                                    <input type="text" class="form-control" name="category.no" value="${product.category.no}">
                                </div>
                                <div class="form-group mb-3 col-3">
                                    <label class="form-label">브랜드</label>
                                    <input type="text" class="form-control" name="brand.no" value="${product.brand.no}">
                                </div>
                                <div class="form-group mb-3 col-6">
                                    <label class="form-label">상품명</label>
                                    <input type="text" class="form-control" name="name" value="${product.name}">
                                </div>
                                <div class="form-group mb-3 col-4">
                                    <label class="form-label">가격</label>
                                    <input type="text" class="form-control" name="price" value="${product.price}"/>
                                </div>
                                <div class="form-group mb-3 col">
                                    <label class="form-label">상품 내용</label>
                                    <textarea type="text" class="form-control" rows="10" cols="10" name="content">${product.content}</textarea>
                                </div>
                                <div class="form-group mb-3 col-4">
                                    <label class="form-label">상품 판매 상태</label>
                                    <input type="text" class="form-control" name="status" value="${product.status}"/>
                                </div>
                                <div class="form-group mb-3 col">
                                    <label class="form-label">썸네일</label>
                                    <input type="text" class="form-control" name="imgThum" value="${product.imgThum}"/>
                                </div>
                                    <div class="form-group mb-3 col-4">
                                        <label class="form-label">대표 색상 설정</label>
                                        <select name="colorNum" class="form-control" id="colorNum">
                                            <c:forEach var="c" items="${colors}">
                                                <option value="${c.no}">${c.name}</option>
                                            </c:forEach>
                                        </select>
                                    </div>
                                <div class="row justify-content-end">
                                    <div class="text-end" style="text-align: right">
                                        <a type="button" class="btn btn-dark mr-2" href="/admin/register-color?no=${param.no}&colorNo=${param.colorNo}">뒤로가기</a>
                                    </div>
                                    <div class="text-end" style="text-align: right">
                                        <button type="submit" class="btn btn-primary mr-1">수정</button>
                                    </div>
                                </div>
                            </form>
                                    <div class="text-end pt-2" style="text-align: right" >
                                        <a href="register-size?no=${param.no}&colorNo=${param.colorNo}">
                                            <button class="btn btn-outline btn-success mr-2">상품 사이즈 추가</button>
                                        </a>
                                    </div>
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

</body>
<script type="text/javascript">
    window.onload = function() {
        <%-- 성공 메시지 확인 후 alert 출력 --%>
        <c:if test="${not empty successMessage}">
        alert("${successMessage}");
        </c:if>

        <%-- 에러 메시지 확인 후 alert 출력 --%>
        <c:if test="${not empty errorMessage}">
        alert("${errorMessage}");
        </c:if>
    }
</script>
</html>



