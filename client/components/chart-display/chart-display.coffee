###
  Displays chart by it's description
  Receives chart description as template context
###
Template.ChartDisplay.onRendered ->
  @autorun =>
    Template.currentData()
    series = Series.find({chartId: @data._id, visible: true}).fetch()
    @$(".highchart-chart").highcharts defaultChartOptions @data.name, series


defaultChartOptions = (title, series) ->
#  find min of series mins
  min = false
  series.forEach (entry) -> if min is false or entry.min < min then min = entry.min

  console.log 'min ', min

  chart:
    type: 'column'
  title:
    text: title
  yAxis:
    min: min,
  plotOptions:
    column:
      pointPadding: 0.2,
      borderWidth: 0
  series: series
