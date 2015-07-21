Template.googleAnalytics.onRendered ->
  tpl = @
  tpl.chartType = new ReactiveVar "line"
  tpl.rawData = new ReactiveVar ""
  tpl.axisNames = new ReactiveVar ""

  Tracker.autorun ->
    rawData = tpl.rawData.get()
    chartType = tpl.chartType.get()
    axisNames = tpl.axisNames.get()

    xData = _.map rawData, (el) -> el[0]
    yData = _.map rawData, (el) -> el[1]
    yData2 = {}

    seriesData = [
      {name: axisNames?.y, data: yData}
    ]

    yAxisConfig = [
      title:
        text: axisNames?.y or ""
      plotLines: [{
        value: 0
        width: 1
        color: '#808080'
      }]
    ]

    if hasSecondYAxis = rawData?[0]?[2]
      yData2 = _.map rawData, (el) -> el[2]
      seriesData.push {name: axisNames.y2, data: yData2}
      yAxisConfig.push
        title:
          text: axisNames.y2 or ""

    # output debug info
    $("textarea").val("#{xData}\n#{JSON.stringify seriesData}")

    initHighCharts = ->
      @.$("#chart").highcharts
        chart:
          type: chartType
        xAxis:
          categories: xData
          title:
            text: axisNames?.x or ""
        yAxis: yAxisConfig
        series: seriesData

    initHighCharts()

  initDatepicker = =>
    @.$('#gaDatepicker').datepicker
      format: "yyyy-mm-dd",
      startDate: "2007-12-01",
      autoclose: true,
      orientation: "top right"
      todayHighlight: true

  initProfilesSelect = =>
    @.$("#profile-selector").select2()

  initAuthButton = =>
    Meteor.call "GA.generateAuthUrl", (err, result) ->
      @.$("#auth-with-ga").attr "href", result

  initDatepicker()
  initProfilesSelect()
  initAuthButton()
