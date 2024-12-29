<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@include file="/WEB-INF/views/common/tags.jsp" %>
<!DOCTYPE html>
<html lang="en">

<head>
    <%@include file="/WEB-INF/views/common/common.jsp" %>
    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
    <meta name="description" content="">
    <meta name="author" content="">

    <title>SB Admin 2 - Dashboard</title>

    <!-- Custom fonts for this template-->
    <link href="${pageContext.request.contextPath}/resources/vendor/fontawesome-free/css/all.min.css" rel="stylesheet"
          type="text/css">
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
                    <h1 class="h3 mb-0 text-gray-800">새 레슨 등록</h1>
                </div>
                <div class="container my-3">
                    <div class="row mb-3">
                        <div class="col">
                            <div class="border p-2 bg-dark text-white fw-bold">새 레슨 등록폼</div>
                        </div>
                    </div>
                    <div class="row mb-3">
                        <div class="col-12">
                            <form:form method="post" id="form-register" modelAttribute="form"
                                       enctype="multipart/form-data">
                            <div class="row p-3">
                                <div class="col-6">
                                    <label for="title">레슨명</label>
                                    <form:input type="text" class="form-control" path="title" id="title" />
                                    <div class="text-danger">
                                        <form:errors path="title"/>
                                    </div>
                                </div>
                            </div>
                            <div class="row p-3">
                                <div class="col-2">
                                    <label for="subject">과정</label>
                                    <form:select path="subject" class="form-control" id="subject">
                                        <option>호흡</option>
                                        <option>자세</option>
                                        <option>운동</option>
                                    </form:select>
                                    <div class="text-danger">
                                        <form:errors path="subject"/>
                                    </div>
                                </div>
                                <div class="col-2">
                                    <label for="lecturerName">강사명</label>
                                    <form:select path="lecturerId" class="form-control" id="lecturerName">
                                        <c:forEach var="lecturer" items="${lecturers}">
                                            <form:option value="${lecturer.id}">${lecturer.name}</form:option>
                                        </c:forEach>
                                    </form:select>
                                </div>
                                <div class="col-2">
                                    <label for="price">가격</label>
                                    <form:input type="number" class="form-control" path="price" id="price" />
                                    <div class="text-danger">
                                        <form:errors path="price"/>
                                    </div>
                                </div>
                            </div>
                            <div class="row p-3 ">
                                <div class="col-5">
                                    <label for="place">장소</label>
                                    <form:input type="text" class="form-control" path="place" id="place"/>
                                    <div class="text-danger">
                                        <form:errors path="place"/>
                                    </div>
                                </div>
                            </div>
                            <div class="row row-cols-1 p-3">
                                <div class="col-1 pb-3">
                                    게시글
                                </div>
                                <div class="col">
                                    <form:textarea class="form-control" rows="10" cols="10" path="plan"></form:textarea>
                                </div>
                                <form:errors path="plan" cssClass="text-danger" />
                            </div>
                            <div class="row p-3">
                                <div class="row p-3">
                                    <div class="col-3">
                                        <label for="startDate">시작 시간</label>
                                        <form:input type="datetime-local" class="form-control" path="startDate"
                                               id="startDate" />
                                        <div class="text-danger">
                                            <form:errors path="startDate"/>
                                        </div>
                                    </div>
                                    <div class="col-3">
                                        <label for="endDate">종료 시간</label>
                                        <form:input type="datetime-local" class="form-control" path="endDate"
                                               id="endDate" />
                                        <div class="text-danger">
                                            <form:errors path="endDate"/>
                                        </div>
                                    </div>
                                    <div class="text-danger" id="endDateError" style="display:none;">
                                        종료 날짜는 시작 날짜 이후이어야 합니다.
                                    </div>
                                </div>
                            </div>
                        </div>
                        <div class="row p-3 ">
                            <div class="col-5">
                                <label for="thumbnail">썸네일 이미지</label>
                                <form:input type="file" class="form-control" path="thumbnail" id="thumbnail"/>
                            </div>
                            <div class="text-danger">
                                <form:errors path="thumbnail"/>
                            </div>
                        </div>
                        <div class="row p-3 ">
                            <div class="col-5">
                                <label for="mainImage">본문 이미지</label>
                                <input type="file" class="form-control" name="mainImage" id="mainImage"/>
                            </div>
                             <form:errors path="mainImage" cssClass="text-danger" />
                        </div>
                        <div class="row p-3">
                            <div class="col d-flex justify-content-end">
                                <a href="/lesson" class="btn btn-secondary m-1">취소</a>
                                <button type="submit" class="btn btn-primary m-1">등록</button>
                            </div>
                        </div>
                        </form:form>
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
    document.querySelector("#form-register").addEventListener("submit", function (event) {

        // 날짜 입력값 가져오기
        const startDate = document.getElementById("startDate").value;
        const endDate = document.getElementById("endDate").value;

        console.log("Start Date:", startDate);  // 디버깅용 로그
        console.log("End Date:", endDate);      // 디버깅용 로그

        // 오류 메시지 요소
        const endDateError = document.getElementById("endDateError");

        // 오류 초기화 (숨김 처리)
        endDateError.style.display = "none";

        // 날짜 비교 로직
        if (startDate && endDate) {
            const start = new Date(startDate);
            const end = new Date(endDate);

            console.log("Parsed Start Date:", start);  // 디버깅용 로그
            console.log("Parsed End Date:", end);      // 디버깅용 로그

            if (start >= end) {
                // 시작 날짜가 종료 날짜보다 늦을 때 오류 처리
                endDateError.style.display = "block";

                event.preventDefault();
                return;
            }
        }

        document.querySelector("#form-register").submit();
    });
</script>

</body>

</html>



