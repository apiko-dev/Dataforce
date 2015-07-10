Template.main.onRendered ->
  @.$('.input-daterange').datepicker
    format: "yyyy-mm-dd",
    startDate: "2007-12-01",
    autoclose: true,
    orientation: "top right"
    todayHighlight: true

  Tracker.autorun ->
    rawData = Session.get "UAProfileData"

    chartType = Session.get "chartType"
    axisNames = Session.get "axisNames"

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

    @.$("#chart").highcharts
      chart:
        type: chartType
      xAxis:
        categories: xData
        title:
          text: axisNames?.x or ""
      yAxis: yAxisConfig
      series: seriesData

Template.main.helpers
  GAaccounts: ->
    Session.get "GAaccounts"

  metrics: ->
    gaMetricsList

  dimensions: ->
    gaDimensionsList

  UAProfileData: ->
    Session.get "UAProfileData"

  addMoreYAxis: ->
    Session.get("addMoreYAxis") or false

  stringify: (obj) ->
    JSON.stringify obj

Template.main.events
  'click #auth-with-ga': (e, t) ->
    Meteor.call "getGAAuthUrl", (err, result) ->
      t.$("#auth-with-ga").attr "href", result

  'click #getUAlist': ->
    Meteor.call "getGAaccounts", Meteor.userId(), (err, result) ->
      Session.set "GAaccounts", result.result

  'click #chart-type-selector': (e, t) ->
    selectedChartType = t.$(e.target).val()
    Session.set "chartType", selectedChartType

  'click #more-axis-checkbox': (e, t) ->
    addSecondAxis = t.$(e.target).prop "checked"
    Session.set "addMoreYAxis", addSecondAxis

  'click #getData': (e, t) ->
    firstMetric = t.$("#metrics-selector").val()
    secondMetric = if (secondMetric = t.$("#second-metrics-selector").val())? then "," + secondMetric else ""

    query =
      profileId: t.$("#profile-selector").val()
      metrics: firstMetric + secondMetric
      dimensions: t.$("#dimensions-selector").val()
      from: t.$("#datepicker input").eq(0).val()
      to: t.$("#datepicker input").eq(1).val()

    console.log query

    Meteor.call "getUAProfileData", query, (err, result) ->
      UAProfileData = _.map result.result, (el) ->
        el[1] = parseInt el[1]
        el[2] = parseInt el[2] if el[2]
        el
      Session.set "UAProfileData", UAProfileData
      Session.set "axisNames",
        x: _.find(gaDimensionsList, (el) -> el.key is query.dimensions).value
        y: _.find(gaMetricsList, (el) -> el.key is firstMetric).value
        y2: _.find(gaMetricsList, (el) -> el.key is secondMetric)?.value
