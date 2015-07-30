_.extend App.DataMisc, {
  chartPreview: (series) ->
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
}