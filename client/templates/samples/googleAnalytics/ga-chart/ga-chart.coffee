Template.gaChart.onCreated ->
  @chartType = new ReactiveVar "line"
  @rawData = new ReactiveVar ""
  @axisNames = new ReactiveVar ""

Template.gaChart.onRendered ->
  tpl = @
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

Template.gaChart.events
  'click #chart-type-selector': (e, t) ->
    selectedChartType = t.$(e.target).val()
    Template.instance().chartType.set selectedChartType

  'click #getData': (e, t) ->
    firstMetric = $("#metrics-selector").val()
    secondMetric = $("#second-metrics-selector").val() or ""
    profileId = $("#profile-selector").val()
    dimensions = $("#dimensions-selector").val()
    fromDate = $("#gaDatepicker input").eq(0).val()
    endDate = $("#gaDatepicker input").eq(1).val()

    chartQuery =
      profileId: profileId
      metrics: firstMetric + "," + secondMetric
      dimensions: dimensions
      from: fromDate
      to: endDate

    console.log chartQuery

    Meteor.call "GA.getUAProfileData", chartQuery, (err, result) ->
      UAProfileData = _.map result.result, (el) ->
        el[1] = parseInt el[1]
        el[2] = parseInt el[2] if el[2]
        el
      t.rawData.set UAProfileData
      t.axisNames.set
        x: _.find(gaDimensionsList, (el) -> el.key is chartQuery.dimensions).value
        y: _.find(gaMetricsList, (el) -> el.key is firstMetric).value
        y2: _.find(gaMetricsList, (el) -> el.key is secondMetric).value or ""
