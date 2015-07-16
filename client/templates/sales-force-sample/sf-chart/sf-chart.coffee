Template.SalesForceChart.onCreated ->
  @getCredentials = =>
    accessToken: @data.accessToken
    instanceUrl: @data.instanceUrl

  @getAmountByStages = (opportunities)->
    seriesNames = []
    seriesValues = []

    indexOfStage = (stage) ->
      index = seriesNames.indexOf(stage)
      if index < 0
        index = seriesNames.length
        seriesNames.push stage
        seriesValues.push(0)
      return index

    updateStage = (stage, value) ->
      index = indexOfStage(stage)
      seriesValues[index] += value

    opportunities.forEach (opp) -> updateStage opp.StageName, opp.Amount

    #convert to series
    return seriesNames.map((name, index) -> {
    name: name,
    data: [seriesValues[index]]
    }).sort (a1, a2) -> a1.data[0] - a2.data[0]


Template.SalesForceChart.onRendered ->
  @initializeChart = (series) =>
    @$(".sf-chart").highcharts
      chart:
        type: 'column'
      title:
        text: 'Opportunities\' amount by status'
      xAxis:
        categories: ['Status'],
        crosshair: true
      yAxis:
        min: 0,
        title:
          text: '$'
      plotOptions:
        column:
          pointPadding: 0.2,
          borderWidth: 0
      series: series

  Meteor.call 'getOpportunities', @getCredentials(), (err, opportunities) =>
    series = @getAmountByStages(opportunities)
    @initializeChart(series)