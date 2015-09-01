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
#  find min of series mins and dimension type
  min = false
  xAxisType = 'linear'

  series.forEach (entry) ->
    if min is false or entry.min < min then min = entry.min
    if entry.dimension and entry.dimension.type is 'date' then xAxisType = 'datetime'

  chart:
    type: 'column'
  title:
    text: title
  xAxis:
    type: xAxisType
  yAxis:
    min: min,
  plotOptions:
    column:
      pointPadding: 0.2,
      borderWidth: 0
  series: series
