Template.zendeskExample.onRendered ->
  Session.set "axisNames",
    x: "Date"
    y: []

  Tracker.autorun ->
    rawData = Session.get "chartData"
    chartType = Session.get "chartType"
    axisNames = Session.get "axisNames"
    if rawData is undefined then return

    xData = _.map rawData[0], (el) -> el[0]
    seriesData = []
    yAxisConfig = []

    addNewLine = (axisData, axisName) ->
      seriesData.push
        name: axisName
        data: axisData
      yAxisConfig.push
        title:
          text: axisName

    for rawAxisData, i in rawData
      yData = _.map rawAxisData, (el) -> el[1]
      addNewLine yData, axisNames.y?[i] or "-"

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
  "click #load-stats": ->
    zendesk = new App.DataAdapters.Zendesk {query: App.DataMisc.ZendeskQueries.OPENED_TICKETS}
    zendesk.getSeries (result) ->
      console.log "The result is:   " + result

#    Meteor.call "getOpenTicketsNumber", (err, result) ->
#      fillResultSpan ".opened-tickets-ctnr", err, result.result
#    Meteor.call "getSolvedTicketsNumber", (err, result) ->
#      fillResultSpan ".solved-tickets-ctnr", err, result.result
#    Meteor.call "getSatisfactionRatingForLastWeek", yes, (err, result) ->
#      fillResultSpan ".satisfaction-rating-ctnr", err, result.result + "%"
#    Meteor.call "getBacklogItemsNumber", (err, result) ->
#      fillResultSpan ".backlog-ctnr", err, result.result

  "click .solved-tickets-ctnr": ->
    Meteor.call "getSolvedTicketsForLastWeek", (err, result) ->
      if not err
        newChartData = Session.get "chartData"
        newChartData.push result
        Session.set "chartData", newChartData
        addYAxisName "Solved tickets"
      else
        console.log err

  "click .satisfaction-rating-ctnr": ->
    Meteor.call "getSatisfactionRatingForLastWeek", no, (err, result) ->
      if not err
        newChartData = Session.get "chartData"
        if not _.isArray newChartData
          newChartData = []
        newChartData.push result

        Session.set "chartData", newChartData
        addYAxisName "Satisfaction Rating"
      else
        console.log err

  "click .chartable.new-tickets-ctnr": (e, t) ->
    console.log "new tickets by date", moment().format("DD-MM-YYYY")
    Meteor.call "getNewTicketsStatsForSevenDays", (err, result) ->
      if not err
        Session.set "chartData", [result]
        addYAxisName "Number of tickets"
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

addYAxisName = (axisName) ->
  axisNames = Session.get("axisNames")
  axisNames.y.push axisName
  Session.set "axisNames", axisNames