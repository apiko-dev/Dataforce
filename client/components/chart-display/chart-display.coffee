###
  Displays chart by it's description
  Receives chart description as template context
###
Template.ChartDisplay.onRendered ->
  @autorun =>
    console.log 'data changed: from cd tracker'
    Template.currentData()
    series = Series.find({chartId: @data._id, visible: true}).fetch()
    @$(".highchart-chart").highcharts defaultChartOptions @data.name, series


defaultChartOptions = (title, series) ->
  chart:
    type: 'column'
  title:
    text: title
  yAxis:
    min: 0,
  plotOptions:
    column:
      pointPadding: 0.2,
      borderWidth: 0
  series: series
