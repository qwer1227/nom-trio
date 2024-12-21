// Set new default font family and font color to mimic Bootstrap's default styling
Chart.defaults.global.defaultFontFamily = 'Nunito', '-apple-system,system-ui,BlinkMacSystemFont,"Segoe UI",Roboto,"Helvetica Neue",Arial,sans-serif';
Chart.defaults.global.defaultFontColor = '#858796';


$(document).ready(function () {
  // 차트 초기화
  const ctx = document.getElementById("myPieChart");
  const myPieChart = new Chart(ctx, {
    type: 'doughnut',
    data: {
      labels: [], // 라벨은 AJAX 응답으로 업데이트됩니다.
      datasets: [{
        data: [], // 데이터는 AJAX 응답으로 업데이트됩니다.
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

  // 데이터 가져오기 버튼 클릭 이벤트
  $('#loadData').click(function () {
    const selectedDate = $('#dateInput').val();

    $.ajax({
      url: '/admin/getChart', // API 엔드포인트
      type: 'GET',
      data: {day: selectedDate}, // 선택한 날짜를 파라미터로 전달
      success: function (response) {
        // 응답 데이터를 차트에 적용
        const labels = response.labels; // 응답에서 labels 키 추출
        const data = response.data;     // 응답에서 data 키 추출

        // 데이터가 모두 0일 경우 처리
        if (data.every(value => value === 0)) {
          $('#myPieChart').hide(); // 차트 숨기기
          $('#noDataMessage').show(); // "결제내역이 없습니다" 메시지 표시
        } else {
          // 차트 데이터 업데이트
          myPieChart.data.labels = labels;
          myPieChart.data.datasets[0].data = data;

          // 차트 업데이트
          myPieChart.update();

          // 차트 보여주고 메시지 숨기기
          $('#myPieChart').show();
          $('#noDataMessage').hide();
        }
      },
      error: function (xhr, status, error) {
        console.error('Error:', error);
        $('#result').text('데이터를 가져오는 중 에러가 발생했습니다.');
      }
    });
  });
});



  var ctx = document.getElementById("myPieChart2");
  var myPieChart2 = new Chart(ctx, {
    type: 'doughnut',
    data: {
      labels: [],
      datasets: [{

        data: [],
        backgroundColor: ['#4e73df', '#1cc88a', '#36b9cc'],
        hoverBackgroundColor: ['#3366ff', '#21ffb2', '#3fe6ff'],
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

// 데이터 가져오기 버튼 클릭 이벤트
$('#loadData').click(function () {
  const selectedDate = $('#dateInput').val(); // 입력된 날짜 가져오기

  $.ajax({
    url: '/admin/getChart', // API 엔드포인트
    type: 'GET',
    data: { day: selectedDate }, // 선택한 날짜를 파라미터로 전달
    success: function (response) {
      // 응답 데이터 추출
      const labels = response.labels2; // labels2 가져오기
      const data = response.data2;     // data2 가져오기

      // 데이터가 모두 0일 경우 처리
      if (data.every(value => value === 0)) {
        $('#myPieChart2').hide(); // 차트 숨기기
        $('#noDataMessage2').show(); // "데이터가 없습니다" 메시지 표시
      } else {
        // 차트 데이터 업데이트
        myPieChart2.data.labels = labels;
        myPieChart2.data.datasets[0].data = data;

        // 차트 업데이트
        myPieChart2.update();

        // 차트 보여주고 메시지 숨기기
        $('#myPieChart2').show();
        $('#noDataMessage2').hide();
      }
    },
    error: function (xhr, status, error) {
      console.error('Error:', error);
      $('#result').text('데이터를 가져오는 중 에러가 발생했습니다.');
    }
  });
});
