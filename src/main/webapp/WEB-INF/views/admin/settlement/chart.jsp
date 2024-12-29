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
  <script src="https://cdnjs.cloudflare.com/ajax/libs/Chart.js/4.4.0/chart.umd.min.js"></script>
  <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
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
          <h1 class="h3 mb-0 text-gray-800">매출</h1>
        </div>
        <div class="row col-6 pt-3 mb-3 align-items-center">
          <label for="dateInput" class="col-auto col-form-label">날짜</label>
          <div class="col-3">
            <%
              // 현재 날짜 가져오기
              SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
              String currentDate = sdf.format(new Date()); // 현재 날짜를 "yyyy-MM-dd" 형식으로 변환
            %>
            <input
                    type="date"
                    name="day"
                    id="dateInput"
                    value="<%= currentDate %>"
                    class="form-control form-control-sm rounded-pill border-gray"
            />
          </div>
          <button id="loadData" class="btn btn-primary">조회</button>
        </div>
        <div id="result" class="mt-4"></div>

        <div class="row">
          <div class="col-xl-4 col-lg-5">
            <div class="card shadow mb-4">
              <!-- Card Header - Dropdown -->
              <div
                      class="card-header py-3 d-flex flex-row align-items-center justify-content-center">
                <h6 class="m-0 font-weight-bold text-primary">과목별 레슨 결제량</h6>
              </div>
              <!-- Card Body -->
              <div class="card-body">
                <div class="chart-pie pt-4 pb-2">
                  <canvas id="myPieChart"></canvas>
                  <div id="noDataMessage" style="display: none; text-align: center; color: #ff0000; font-size: 18px;">
                    결제내역이 없습니다.
                  </div>
                </div>
                <div class="mt-4 text-center small">
                  <span class="mr-2">
                      <i class="fas fa-circle" style="color: #FF6B6B;"></i> 호흡
                  </span>
                  <span class="mr-2">
                      <i class="fas fa-circle" style="color: #4ECDC4;"></i> 자세
                  </span>
                  <span class="mr-2">
                      <i class="fas fa-circle" style="color: #FFD93D;"></i> 운동
                  </span>
                </div>
              </div>
            </div>
          </div>
          <div class="col-xl-4 col-lg-5">
            <div class="card shadow mb-4">
              <!-- Card Header - Dropdown -->
              <div
                      class="card-header py-3 d-flex flex-row align-items-center justify-content-center">
                <h6 class="m-0 font-weight-bold text-primary">카테고리별 상품 판매량</h6>
              </div>
              <!-- Card Body -->
              <div class="card-body">
                <div class="chart-pie pt-4 pb-2">
                  <canvas id="myPieChart2"></canvas>
                  <div id="noDataMessage2" style="display: none; text-align: center; color: #ff0000; font-size: 18px;">
                    결제내역이 없습니다.
                  </div>
                </div>
                <div class="mt-4 text-center small">
                  <span class="mr-2">
                    <i class="fas fa-circle text-primary"></i> 남성상품
                  </span>
                  <span class="mr-2">
                    <i class="fas fa-circle text-success"></i> 여성상품
                  </span>
                  <span class="mr-2">
                    <i class="fas fa-circle text-info"></i> 런닝용품
                  </span>
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

</script>
</html>
