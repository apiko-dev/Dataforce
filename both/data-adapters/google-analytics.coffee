class GoogleAnalyticsDataAdapter
  constructor: (@chartQuery, @json) ->

  @_axisNames: []

  _getXAxisName: ->
    dimensions = @chartQuery.dimensions
    dimensionsDescription = _.find(gaDimensionsList, (el) ->
      el.key is dimensions)?.value or ""

  _getYAxisesNames: ->
    metricsList = @chartQuery.metrics.split ","
    axisesCount = metricsList.length
    yAxisesNames = []

    _(axisesCount).times (i) =>
      metricsObj = _.find(gaMetricsList, (el) ->
        el.key is metricsList[i])
      metricsDescription = metricsObj?.value
      yAxisesNames.push metricsDescription or ""
    yAxisesNames

  getCategories: ->
    _.map @json.result.rows, (el) ->
      el[0]

  getAxisNames: ->
    @_axisNames =
      x: @_getXAxisName()
      y: @_getYAxisesNames()

  getSeries: ->
    # example series [{data: [119, 56], name: "abc"}, {data: [100, 23], name: "def"}]
    series = []
    rows = @json.result.rows
    axisesCount = rows[0].length - 1
    axisNames = @_axisNames

    _(axisesCount).times (axisIndex) ->
      series.push
        data: _.map rows, (row) ->
          arr = []
          for element, index in row
            if index is (axisIndex + 1)
              arr.push parseInt element
          arr
        name: axisNames.y[axisIndex]
    if @chartQuery.mergeMetrics
      seriesMerger = new App.DataMisc.GASeriesMerger series[0].data, series[1].data
      seriesMerger.getSeries()
    else
      series


_.extend App.DataAdapters, {
  GoogleAnalytics: GoogleAnalyticsDataAdapter
}