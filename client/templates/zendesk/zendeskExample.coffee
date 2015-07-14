Template.zendeskExample.onRendered ->
  Tracker.autorun ->
    rawData = Session.get "chartData"

    if rawData is undefined then return

    chartType = Session.get "chartType"
    axisNames = Session.get "axisNames"

    xData = _.map rawData[0], (el) -> el[0]
    yData = _.map rawData[0], (el) -> el[1]
    yData2 = {}
    yData3 = {}

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

    if hasSecondYAxis = rawData?[1]
      yData2 = _.map rawData[1], (el) -> el[1]
      seriesData.push {name: axisNames.y2, data: yData2}
      yAxisConfig.push
        title:
          text: axisNames.y2 or "No name"

    if hasThirdAxis = rawData?[2]
      yData3 = _.map rawData[2], (el) -> el[1]
      seriesData.push {name: axisNames?.y3, data: yData3}
      yAxisConfig.push
        title:
          text: axisNames?.y3 or "No name"

    console.log xData
    console.log yData
    console.log yData2
    console.log yData3

    @.$("#chart").highcharts
      chart:
        type: chartType
      xAxis:
        categories: xData
        title:
          text: axisNames?.x or ""
      yAxis: yAxisConfig
      series: seriesData

Template.zendeskExample.helpers
  newTickets: ->
    _.map(Session.get("chartData"), (el) -> el[1]).length

Template.zendeskExample.events
  "click #load-stats": (e, t) ->
    Meteor.call "getOpenTicketsNumber", (err, result) ->
      fillResultSpan ".opened-tickets-ctnr", err, result
    Meteor.call "getSolvedTicketsNumber", (err, result) ->
      fillResultSpan ".solved-tickets-ctnr", err, result
    Meteor.call "getSatisfactionRatingForLastWeek", yes, (err, result) ->
      fillResultSpan ".satisfaction-rating-ctnr", err, result + "%"
    Meteor.call "getBacklogItemsNumber", (err, result) ->
      fillResultSpan ".backlog-ctnr", err, result

  "click .solved-tickets-ctnr": (e, t)->
    Meteor.call "getSolvedTicketsForLastWeek", (err, result) ->
      console.log err, result
      if not err
        newChartData = Session.get "chartData"
        newChartData.push result
        Session.set "chartData", newChartData

  "click .satisfaction-rating-ctnr": (e, t)->
    Meteor.call "getSatisfactionRatingForLastWeek", no, (err, result) ->
      console.log err, result
      if not err
        newChartData = Session.get "chartData"
        if not _.isArray newChartData
          newChartData = []
        newChartData.push result
        Session.set "chartData", newChartData

  "click .chartable.new-tickets-ctnr": (e, t) ->
    console.log "new tickets by date",  moment().format("DD-MM-YYYY")
    Meteor.call "getNewTicketsStatsForSevenDays", (err, result) ->
      if not err
        Session.set "chartData", [result]
        Session.set "axisNames", {x: "Date", y: "Number of tickets"}
      else
        console.log err

  "click #chart-type-selector": (e, t) ->
    chartTypeValue = t.$(e.target).val()
    console.log chartTypeValue
    Session.set "chartType", chartTypeValue

  "click #chart-date-selector": (e, t) ->
    chartDateRangeValue = t.$(e.target).val()
    console.log chartDateRangeValue
    Session.set "chartDateRange", chartDateRangeValue

fillResultSpan = (parentSelector, err, result) ->
  resultSpan = $("#{parentSelector} .result")
  if err
    resultSpan.text err
  else
    resultSpan.text result
