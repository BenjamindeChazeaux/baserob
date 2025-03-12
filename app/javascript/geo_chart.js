document.addEventListener('DOMContentLoaded', function() {
  const geoChartElement = document.getElementById('geoChart');
  
  if (geoChartElement) {
    const ctx = geoChartElement.getContext('2d');
    new Chart(ctx, {
      type: 'doughnut',
      data: {
        labels: ['Europe', 'Amérique du Nord', 'Asie'],
        datasets: [{
          data: [45, 35, 20],
          backgroundColor: ['#333333', '#666666', '#999999']
        }]
      },
      options: {
        responsive: true,
        maintainAspectRatio: false,
        plugins: {
          legend: {
            display: false
          }
        },
        cutout: '70%'
      }
    });
  }
}); 