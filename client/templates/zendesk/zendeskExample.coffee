Template.zendeskExample.onRendered ->
  Tracker.autorun ->
    rawData = Session.get "chartData"

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
    console.log "Loading statistic..."
    Meteor.call "getOpenTicketsNumber", (err, result) ->
      console.log err, result
      t.$(".opened-tickets-ctnr .result").text(result.result)
      if err
        t.$(".opened-tickets-ctnr .result").text(err)

  "click .chartable.new-tickets-ctnr": (e, t) ->
    console.log "new tickets by date",  moment().format("DD-MM-YYYY")
    Meteor.call "getNewTicketsStatsForSevenDays", (err, result) ->
      if not err
        Session.set "chartData", result
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