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
          <h1 class="h3 mb-0 text-gray-800">코스 상세</h1>
        </div>
        <div class="row">
          <div class="col-5">
              <table class="table table-bordered">
                  <div class="card">
                      <div class="card-header">${course.name}</div>
                  </div>
                  <tbody>
                  <tr>
                      <th scope="row">코스 지역</th>
                      <td>${course.region.si} ${course.region.gu} ${course.region.dong}</td>
                  </tr>
                  <tr>
                      <th scope="row">코스 거리</th>
                      <td>${course.distance}KM</td>
                  </tr>
                  <tr>
                      <th scope="row">평균 완주 시간</th>
                      <td>${course.time}분</td>
                  </tr>
                  <tr>
                      <th scope="row">코스 난이도</th>
                      <td>${course.level}단계</td>
                  </tr>
                  </tbody>
              </table>
              <div class="row mt-3 mb-3 justify-content-center">
                  <span>좋아요 수 : ${course.likeCnt}개</span>
              </div>
              <div class="row justify-content-end">
                <a type="button" class="btn btn-primary justify-content-end mr-2" href="course">뒤로가기</a>
                <a type="button" class="btn btn-warning justify-content-end mr-2" href="course-edit-form?no=${param.no}">수정</a>
                <form method="post" action="/admin/course-delete">
                    <input type="hidden" name="no" value="${param.no}">
                    <button type="button" class="btn btn-danger" onclick="confirmDelete(this)">삭제</button>
                </form>
              </div>
          </div>
        <div class="col-6">
            <div class="card">
                <div class="card-body">
                    <div class="row mb-1">
                        <div class="col">
                            <img src="${s3}/resources/images/course/${course.filename}" class="img-thumbnail">
                        </div>
                    </div>
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
<script>
    function confirmDelete(button) {
        // 삭제 확인창 띄우기
        const confirmResult = confirm("정말 삭제하시겠습니까?");

        // 사용자가 '확인'을 클릭하면
        if (confirmResult) {
            // 부모 폼을 찾아서 submit을 실행
            button.closest('form').submit();
        }
        // 취소를 클릭하면 아무 작업도 하지 않음
    }
</script>
</html>

