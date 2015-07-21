Template.SalesForceChart.onRendered ->
  @initializeChart = (chartData) =>
    @$(".sf-chart").highcharts
      chart:
        type: 'column'
      title:
        text: 'Result'
      xAxis:
        categories: chartData.categories,
        crosshair: true
      yAxis:
        min: 0,
        title:
          text: ''
      plotOptions:
        column:
          pointPadding: 0.2,
          borderWidth: 0
      series: chartData.series

  @autorun =>
    chart = Session.get 'sfChart'

    if chart
      transformer = App.DataTransformers.SalesForceDataGrouper
      dataAdapter = new App.DataAdapters.SalesForce(transformer)
      dataAdapter.getHighchartSeries chart, (series) => @initializeChart(series)
