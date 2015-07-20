class Series
  constructor: (@chart, data) ->
    @series = {}

    getDimension2Value = (entry) =>
      if @_is2Dimensional() then entry[@chart.axis.dimension2] else @chart.axis.dimension

    data.forEach (entry) =>
      dimensionValue = entry[@chart.axis.dimension]
      dimension2Value = getDimension2Value(entry)
      value = entry[@chart.axis.metrics]

      @_updateValue(dimension2Value, dimensionValue, value)


  _is2Dimensional: () -> !!@chart.axis.dimension2

  _isAverageValueFunction: () -> @chart.valueFunction is 'average'

  _getSeriesEntry: (functionArguments) -> @series[functionArguments[0]][functionArguments[1]]

  _updateValue: (dimension2Value, dimensionValue, value) ->
    unless @series[dimension2Value] then @series[dimension2Value] = {}
    unless @series[dimension2Value][dimensionValue]
      @series[dimension2Value][dimensionValue] =
        value: if @_isAverageValueFunction() then 1 else 0

    #dispatch value function
    @["_#{@chart.valueFunction}"].apply(@, arguments)


  _sum: (dimension2Value, dimensionValue, value) ->
    seriesEntry = @_getSeriesEntry(arguments)
    seriesEntry.value += value

  _multiply: (dimension2Value, dimensionValue, value) ->
    @_getSeriesEntry(arguments).value *= value

  _average: (dimension2Value, dimensionValue, value) ->
    seriesEntry = @_getSeriesEntry(arguments)
    if seriesEntry.count
      seriesEntry.count++
    else
      seriesEntry.count = 1
    seriesEntry.value += value

  _getValue: (dimension2Value, dimensionValue) ->
    seriesEntry = @_getSeriesEntry(arguments)
    value = if @_isAverageValueFunction() then seriesEntry.value / seriesEntry.count else seriesEntry.value
    #round value up to 2 digits after dot
    Math.round(value * 100) / 100

  getConvertedSeriesForHighchart: ->
    categories = []
    series = []

    seriesByName = (name) ->
      result = false
      for entry in series
        if entry.name is name then result = entry

      unless result
        result = {name: name, data: []}
        series.push result
      return result

    Object.keys(@series).forEach (dimension2Value) =>
      Object.keys(@series[dimension2Value]).forEach (dimensionValue) =>
        value = @_getValue dimension2Value, dimensionValue

        unless dimension2Value in categories then categories.push dimension2Value

        categoryIndex = categories.indexOf(dimension2Value)
        seriesEntry = seriesByName(dimensionValue)
        seriesEntry.data[categoryIndex] = value

    #process series data (replace all undefined to 0)
    series.forEach (seriesEntry) ->
      for i in [0..categories.length - 1]
        value = seriesEntry.data[i]
        seriesEntry.data[i] = unless value then 0 else value

    #return chart data
    categories: categories
    series: series


Template.SalesForceChart.onRendered ->
  @initializeChart = (chartData) =>
    @$(".sf-chart").highcharts
      chart:
        type: 'column'
      title:
        text: 'Result'
      xAxis:
        categories: chartData.categories,
        crosshair: true
      yAxis:
        min: 0,
        title:
          text: ''
      plotOptions:
        column:
          pointPadding: 0.2,
          borderWidth: 0
      series: chartData.series

  @autorun =>
    chart = Session.get 'sfChart'

    console.log chart

    if chart
      Meteor.call 'sfGetTableData', @findParentTemplate('SalesForceSample').getCredentials(), chart.table, chart.filters, (err, tableData) =>
        series = new Series(chart, tableData)
        convertedSeries = series.getConvertedSeriesForHighchart()
        console.log convertedSeries
        @initializeChart convertedSeries