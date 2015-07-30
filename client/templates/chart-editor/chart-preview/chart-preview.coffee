Template.ChartPreview.onRendered ->
  @$("#chart-preview").highcharts App.DataMisc.chartPreview [
    {data: [1,2,3,4,5,6,7,8,9], name: "Example line 1"}
    {data: [1,2,3,4,5,6,7,8,9].reverse(), name: "Example line 2"}
  ]