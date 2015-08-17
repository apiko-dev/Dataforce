###
  Displays chart by it's description
  Receives chart description as template context
###
Template.ChartDisplay.onRendered ->
  @$(".highchart-chart").highcharts chartPreview [
    {data: [1, 2, 3, 4, 5, 6, 7, 8, 9], name: "Example line 1"}
    {data: [1, 2, 3, 4, 5, 6, 7, 8, 9].reverse(), name: "Example line 2"}
  ]

chartPreview = (series) ->
  chart:
    type: 'column'
  title:
    text: 'Preview'
  yAxis:
    min: 0,
  plotOptions:
    column:
      pointPadding: 0.2,
      borderWidth: 0
  series: series
