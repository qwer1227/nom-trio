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
                    <h1 class="h3 mb-0 text-gray-800">레슨 수정</h1>
                </div>
                <form:form method="post" id="form-edit" modelAttribute="form"
                           enctype="multipart/form-data">
                    <div class="container my-3">
                        <div class="row mb-3">
                            <div class="col">
                                <div class="border p-2 bg-dark text-white fw-bold">레슨 수정 폼</div>
                            </div>
                        </div>
                        <form:input type="hidden" path="lessonNo" value="${lesson.lessonNo}"/>
                        <div class="row mb-3">
                            <div class="col-12">

                                <div class="row p-3">
                                    <div class="col-6">
                                        <label for="title">레슨명</label>
                                        <form:input type="text" class="form-control" path="title" id="title"
                                        />
                                        <div class="text-danger">
                                            <form:errors path="title"/>
                                        </div>
                                    </div>
                                </div>
                                <div class="row p-3">
                                    <div class="col-2">
                                        <label>과정</label>
                                        <select name="subject" class="form-control" id="subject">
                                            <option  ${lesson.subject == '호흡' ? 'selected' : ''}>호흡</option>
                                            <option  ${lesson.subject == '자세' ? 'selected' : ''}>자세</option>
                                            <option  ${lesson.subject == '운동' ? 'selected' : ''}>운동</option>
                                        </select>
                                    </div>
                                    <div class="col-2">
                                        <label for="status">상태</label>
                                        <form:select path="status" class="form-control" id="status">
                                            <option ${lesson.status == '모집중' ? 'selected' : ''}>모집중</option>
                                            <option ${lesson.status == '마감' ? 'selected' : ''}>마감</option>
                                            <option ${lesson.status == '취소' ? 'selected' : ''}>취소</option>
                                        </form:select>
                                    </div>
                                    <div class="col-2">
                                        <label for="lecturerName">강사명</label>
                                        <form:select path="lecturerId" class="form-control" id="lecturerName">
                                            <form:options items="${lecturers}" itemValue="id" itemLabel="name"/>
                                        </form:select>
                                    </div>
                                    <div class="col-2">
                                        <label for="price">가격</label>
                                        <form:input type="number" class="form-control" path="price" id="price"
                                                    value="${lesson.price}"/>
                                        <div class="text-danger">
                                            <form:errors path="price"/>
                                        </div>
                                    </div>
                                </div>
                                <div class="row row-cols-1 p-3">
                                    <div class="col-1 pb-3">
                                        게시글
                                    </div>
                                    <div class="col">
                                    <form:textarea class="form-control" rows="10" cols="10"
                                              path="plan"></form:textarea>
                                    </div>
                                    <div class="text-danger">
                                        <form:errors path="plan"/>
                                    </div>
                                </div>
                                <div class="row p-3">
                                    <div class="col-3">
                                        <label for="startDate">시작 시간</label>
                                        <input type="datetime-local" class="form-control" name="start" id="startDate"
                                               value="${lesson.start}" timeZone="GMT">
                                        <div class="text-danger">
                                            <form:errors path="start"/>
                                        </div>
                                    </div>
                                    <div class="col-3">
                                        <label for="endDate">종료 시간</label>
                                        <input type="datetime-local" class="form-control" name="end" id="endDate"
                                               value="${lesson.end}" timeZone="GMT">
                                        <div class="text-danger">
                                            <form:errors path="end"/>
                                        </div>
                                    </div>
                                    <div class="text-danger" id="endDateError" style="display:none;">
                                        종료 날짜는 시작 날짜 이후이어야 합니다.
                                    </div>
                                </div>
                            </div>
                        </div>
                        <div class="row p-3 ">
                            <div class="col-5 ">
                                <c:if test="${not empty images['THUMBNAIL']}">
                                    <img src="${s3}/resources/images/lesson/${images['THUMBNAIL']}"
                                         alt="Thumbnail" id="previewThumbnail" class="p-3"
                                         style="width: 100%;"/>
                                </c:if>
                                <label for="thumbnail">썸네일 이미지</label>
                                <form:input type="file" class="form-control" path="thumbnail" id="thumbnail"
                                            accept="image/*"/>
                                <div class="text-danger">
                                    <form:errors path="thumbnail"/>
                                </div>
                            </div>
                        </div>
                        <div class="row p-3 ">
                            <div class="col-5">
                                <c:if test="${not empty images.MAIN_IMAGE}">
                                    <img src="${s3}/resources/images/lesson/${images['MAIN_IMAGE']}"
                                         alt="Main Image" id="previewMainImage" class="p-3"
                                         style="width: 100%;"/>
                                </c:if>
                                <img
                                        id="previewMainImage"
                                        alt="Main Image Preview"
                                        class="p-3"
                                        style="width: 100%; height: 1000px; display: none;"
                                />
                                <label for="mainImage">본문 이미지</label>
                                <input type="file" class="form-control" name="mainImage" id="mainImage"
                                       accept="image/*"/>
                                <form:errors path="mainImage" cssClass="text-danger"/>
                            </div>
                        </div>
                        <div class="row p-3">
                            <div class="col d-flex justify-content-end">
                                <a href="/admin/lesson" class="btn btn-secondary m-1">취소</a>
                                <a href="/admin/lesson-edit-form?lessonNo=${lessonNo}">
                                    <button type="submit" class="btn btn-primary m-1">수정</button>
                                </a>
                            </div>
                        </div>
                    </div>
                </form:form>
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

    document.getElementById('thumbnail').addEventListener('change', function (event) {
        const file = event.target.files[0];
        if (file) {
            const reader = new FileReader();
            reader.onload = function (e) {
                document.getElementById('previewThumbnail').src = e.target.result;
            };
            reader.readAsDataURL(file);
        }
    });

    document.getElementById('mainImage').addEventListener('change', function (event) {
        const file = event.target.files[0];
        const previewImage = document.getElementById('previewMainImage');

        if (file) {
            const reader = new FileReader();
            reader.onload = function (e) {
                previewImage.src = e.target.result;
                previewImage.style.display = "block"; // 이미지가 선택되면 표시
            };
            reader.readAsDataURL(file);
        } else {
            previewImage.style.display = "none"; // 파일이 없으면 이미지 숨김
        }
    });

    document.querySelector("#form-edit").addEventListener("submit", function (event) {
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

                // 오류가 발생한 위치로 스크롤 이동
                endDateError.scrollIntoView({behavior: "smooth", block: "center"});

                event.preventDefault(); // 폼 제출 중단
                return;
            }
        }

        // 폼 제출
        document.querySelector("#form-edit").submit();
    });

</script>

</body>

</html>



