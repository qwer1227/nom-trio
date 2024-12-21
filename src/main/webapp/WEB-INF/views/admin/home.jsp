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
                    <h1 class="h3 mb-0 text-gray-800">Dashboard</h1>
                </div>

                <!-- Content Row -->
                <div class="row">

                    <!-- Earnings (Monthly) Card Example -->
                    <div class="col-xl-4 col-md-6 mb-4">
                        <div class="card border-left-primary shadow h-100 py-2">
                            <div class="card-body">
                                <div class="row no-gutters align-items-center">
                                    <div class="col mr-2">
                                        <div class="text-xs font-weight-bold text-primary text-uppercase mb-1">
                                            전일 매출액(레슨)</div>
                                        <div id="yesterdayRevenue" class="h5 mb-0 font-weight-bold text-gray-800">0원</div>
                                    </div>
                                    <div class="col-auto">
                                        <i class="fas fa-chalkboard-teacher fa-2x text-gray-300"></i>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>

                    <!-- Earnings (Monthly) Card Example -->
                    <div class="col-xl-4 col-md-6 mb-4">
                        <div class="card border-left-success shadow h-100 py-2">
                            <div class="card-body">
                                <div class="row no-gutters align-items-center">
                                    <div class="col mr-2">
                                        <div class="text-xs font-weight-bold text-success text-uppercase mb-1">
                                            전일 매출액(상품)</div>
                                        <div id="yesterdayProdRevenue" class="h5 mb-0 font-weight-bold text-gray-800">0원</div>
                                    </div>
                                    <div class="col-auto">
                                        <i class="fas fa-box fa-2x text-gray-300"></i>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                    <!-- Pending Requests Card Example -->
                    <div class="col-xl-4 col-md-6 mb-4">
                        <div class="card border-left-warning shadow h-100 py-2">
                            <div class="card-body">
                                <div class="row no-gutters align-items-center">
                                    <div class="col mr-2">
                                        <div class="text-xs font-weight-bold text-warning text-uppercase mb-1">
                                            전일 상품 판매량
                                        </div>
                                        <div id="yesterdayProdAmountRevenue" class="h5 mb-0 font-weight-bold text-gray-800">0</div>
                                    </div>
                                    <div class="col-auto">
                                        <i class="fas fa-shopping-cart fa-2x text-gray-300"></i>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Content Row -->

                <div class="row">

                    <!-- Area Chart -->
                    <div class="col-xl-8 col-lg-7">
                        <div class="card shadow mb-4">
                            <!-- Card Header - Dropdown -->
                            <div
                                    class="card-header py-3 d-flex flex-row align-items-center justify-content-between">
                                <h6 class="m-0 font-weight-bold text-primary">Earnings Overview</h6>
                                <div class="dropdown no-arrow">
                                    <a class="dropdown-toggle" href="#" role="button" id="dropdownMenuLink"
                                       data-toggle="dropdown" aria-haspopup="true" aria-expanded="false">
                                        <i class="fas fa-ellipsis-v fa-sm fa-fw text-gray-400"></i>
                                    </a>
                                    <div class="dropdown-menu dropdown-menu-right shadow animated--fade-in"
                                         aria-labelledby="dropdownMenuLink">
                                        <div class="dropdown-header">Dropdown Header:</div>
                                        <a class="dropdown-item" href="#">Action</a>
                                        <a class="dropdown-item" href="#">Another action</a>
                                        <div class="dropdown-divider"></div>
                                        <a class="dropdown-item" href="#">Something else here</a>
                                    </div>
                                </div>
                            </div>
                            <!-- Card Body -->
                            <div class="card-body">
                                <div class="chart-area">
                                    <canvas id="myAreaChart"></canvas>
                                </div>
                            </div>
                        </div>
                    </div>

                    <!-- Pie Chart -->
                    <div class="col-xl-4 col-lg-5">
                        <div class="card shadow mb-4">
                            <!-- Card Header - Dropdown -->
                            <div
                                    class="card-header py-3 d-flex flex-row align-items-center justify-content-between">
                                <h6 class="m-0 font-weight-bold text-primary">Revenue Sources</h6>
                                <div class="dropdown no-arrow">
                                    <a class="dropdown-toggle" href="#" role="button" id="dropdownMenuLink2"
                                       data-toggle="dropdown" aria-haspopup="true" aria-expanded="false">
                                        <i class="fas fa-ellipsis-v fa-sm fa-fw text-gray-400"></i>
                                    </a>
                                    <div class="dropdown-menu dropdown-menu-right shadow animated--fade-in"
                                         aria-labelledby="dropdownMenuLink">
                                        <div class="dropdown-header">Dropdown Header:</div>
                                        <a class="dropdown-item" href="#">Action</a>
                                        <a class="dropdown-item" href="#">Another action</a>
                                        <div class="dropdown-divider"></div>
                                        <a class="dropdown-item" href="#">Something else here</a>
                                    </div>
                                </div>
                            </div>
                            <!-- Card Body -->
                            <div class="card-body">
                                <div class="chart-pie pt-4 pb-2">
                                    <canvas id="myPieChart3"></canvas>
                                </div>
                                <div id="noDataMessage" style="display: none; text-align: center; color: #ff0000; font-size: 18px;">
                                    금일 결제내역이 없습니다.
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
                </div>

            </div>
        </div>

    </div>
    <!-- /.container-fluid -->

</div>
<!-- End of Main Content -->

<!-- Footer -->
<%@include file="/WEB-INF/views/admincommon/footer.jsp" %>
<!-- End of Footer -->

<%@include file="/WEB-INF/views/admincommon/common.jsp" %>
</body>
<script>
    $(document).ready(function () {
        // 차트 초기화
        const ctx = document.getElementById("myPieChart3");
        const myPieChart3 = new Chart(ctx, {
            type: 'doughnut',
            data: {
                labels: [], // AJAX 응답으로 라벨 업데이트
                datasets: [{
                    data: [], // AJAX 응답으로 데이터 업데이트
                    backgroundColor: ['#FF6B6B', '#4ECDC4', '#FFD93D'],
                    hoverBackgroundColor: ['rgba(255,27,27,0.98)', 'rgba(32,232,216,0.87)', '#ffef23'],
                    hoverBorderColor: "rgba(234, 236, 244, 1)",
                }],
            },
            options: {
                maintainAspectRatio: false,
                tooltips: {
                    backgroundColor: "rgb(255,255,255)",
                    bodyFontColor: "#858796",
                    borderColor: '#dddfeb',
                    borderWidth: 1,
                    xPadding: 15,
                    yPadding: 15,
                    displayColors: false,
                    caretPadding: 10,
                },
                legend: {
                    display: false
                },
                cutoutPercentage: 80,
            },
        });

        // 페이지 로드 시, 현재 날짜에 해당하는 데이터 요청
        $.ajax({
            url: '/admin/getHome', // API 엔드포인트
            type: 'GET',
            success: function (response) {
                // 응답 데이터를 차트에 적용
                const labels = response.labels; // 응답에서 labels 추출
                const data = response.data;     // 응답에서 data 추출
                const yesterdayPrice = response.yesterdayPrice; // 전일 매출액 추출
                const yesterdayProdPrice = response.yesterdayProdPrice;
                const yesterdayTotalProdAmount = response.yesterdayTotalProdAmount;

                // 데이터가 모두 0인지 확인
                const isNoData = data.every(value => value === 0);

                // 데이터가 0이면 메시지 표시
                if (isNoData) {
                    $('#noDataMessage').show();  // "금일 결제내역이 없습니다." 메시지 표시
                    $('#myPieChart3').hide();    // 차트 숨김
                } else {
                    $('#noDataMessage').hide();  // 메시지 숨김
                    $('#myPieChart3').show();   // 차트 표시
                    // 차트 데이터 업데이트
                    myPieChart3.data.labels = labels;
                    myPieChart3.data.datasets[0].data = data;
                    // 차트 업데이트
                    myPieChart3.update();
                }

                // 전일 매출액 업데이트
                $('#yesterdayRevenue').text(yesterdayPrice.toLocaleString() + '원'); // div에 전일 매출액을 표시
                $('#yesterdayProdRevenue').text(yesterdayProdPrice.toLocaleString() + '원'); // div에 전일 상품 매출액을 표시
                $('#yesterdayProdAmountRevenue').text(yesterdayTotalProdAmount.toLocaleString() + '개') // div에 전일 상품 판매수량을 표시

            },
            error: function (xhr, status, error) {
                console.error('Error:', error);
                // 오류 발생 시 처리 (필요한 경우 메시지 표시 등)
            }
        });
    });
</script>
</html>
