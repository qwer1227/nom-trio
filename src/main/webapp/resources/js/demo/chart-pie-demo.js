// Set new default font family and font color to mimic Bootstrap's default styling
Chart.defaults.global.defaultFontFamily = 'Nunito', '-apple-system,system-ui,BlinkMacSystemFont,"Segoe UI",Roboto,"Helvetica Neue",Arial,sans-serif';
Chart.defaults.global.defaultFontColor = '#858796';

$(document).ready(function () {
  // Initialize charts
  const myPieChart = initializeChart("myPieChart", ['#FF6B6B', '#4ECDC4', '#FFD93D'], ['rgba(255,27,27,0.98)', 'rgba(32,232,216,0.87)', '#ffef23']);
  const myPieChart2 = initializeChart("myPieChart2", ['#4e73df', '#1cc88a', '#36b9cc'], ['#3366ff', '#21ffb2', '#3fe6ff']);
  const myPieChart3 = initializeChart("myPieChart3", ['#FF6B6B', '#4ECDC4', '#FFD93D'], ['rgba(255,27,27,0.98)', 'rgba(32,232,216,0.87)', '#ffef23']);
  const myPieChart4 = initializeChart("myPieChart4", ['#4e73df', '#1cc88a', '#36b9cc'], ['#3366ff', '#21ffb2', '#3fe6ff']);

  // Configuration for all charts
  const chartConfigs = [
    { chart: myPieChart, labelsKey: 'labels', dataKey: 'data', chartId: '#myPieChart', messageId: '#noDataMessage' },
    { chart: myPieChart2, labelsKey: 'labels2', dataKey: 'data2', chartId: '#myPieChart2', messageId: '#noDataMessage2' },
    { chart: myPieChart3, labelsKey: 'labels3', dataKey: 'data3', chartId: '#myPieChart3', messageId: '#noDataMessage3' },
    { chart: myPieChart4, labelsKey: 'labels4', dataKey: 'data4', chartId: '#myPieChart4', messageId: '#noDataMessage4' },
  ];

  // Load data on button click
  $('#loadData').click(function () {
    const selectedDate = $('#dateInput').val();

    chartConfigs.forEach(config => {
      $.ajax({
        url: '/admin/getChart',
        type: 'GET',
        data: { day: selectedDate },
        success: function (response) {
          updateChart(config.chart, response[config.labelsKey], response[config.dataKey], config.chartId, config.messageId);
        },
        error: function (xhr, status, error) {
          console.error('Error:', error);
        }
      });
    });
  });
});

function initializeChart(elementId, backgroundColors, hoverColors) {
  const ctx = document.getElementById(elementId);
  return new Chart(ctx, {
    type: 'doughnut',
    data: {
      labels: [],
      datasets: [{
        data: [],
        backgroundColor: backgroundColors,
        hoverBackgroundColor: hoverColors,
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
}

function updateChart(chart, labels, data, chartId, messageId) {
  if (data.every(value => value === 0)) {
    $(chartId).hide();
    $(messageId).show();
  } else {
    chart.data.labels = labels;
    chart.data.datasets[0].data = data;
    chart.update();
    $(chartId).show();
    $(messageId).hide();
  }
}