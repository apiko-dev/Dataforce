###
  Displays chart by it's description
  Receives chart description as template context
###
Template.ChartDisplay.onRendered ->
  @autorun =>
    Template.currentData()
    series = Series.find({'curve.chartId': @data._id, 'curve.visible': true}).fetch()

    @$(".highchart-chart").highcharts defaultChartOptions @data.name, series


defaultChartOptions = (title, series) ->
#  find min of series mins and dimension type
  min = false
  xAxisType = 'linear'

  series.forEach (entry) ->
    if min is false or entry.min < min then min = entry.min

    #if one of the series has date as dimension make it as type of axis
    if entry.curve.metadata and entry.curve.metadata.dimension and entry.curve.metadata.dimension.type is 'date' then xAxisType = 'datetime'

    #add custom tooltips for curves with dataforce source
    if entry.curve.source is ConnectorNames.Dataforce
      entry.tooltip =
        pointFormat: '<span style="color:{point.color}">\u25CF</span> {series.name}: <b>{point.y}</b> for <b>{point.mergeValue}</b><br/>'


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
