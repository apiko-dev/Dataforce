class GoogleAnalyticsDataAdapter
  constructor: (@chartQuery, @json) ->
    console.log @chartQuery
    console.log @json

  _axisNames: []

  getCategories: ->
    _.map @json.result.rows, (el) ->
      el[0]

  getAxisNames: ->
    allMetrics = @chartQuery.metrics.split ","
    dimensions = @chartQuery.dimensions

    @_axisNames =
      x: _.find(gaDimensionsList, (el) ->
        el.key is dimensions).value
      y: []
    _(allMetrics.length).times (i) =>
      @_axisNames.y.push _.find(gaMetricsList, (el) ->
          el.key is allMetrics[i])?.value or ""
    @_axisNames

  getSeries: ->
    # example series [{data: [119, 56]}, {data: [100, 23]}]
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
    series


_.extend App.DataAdapters, {
  GoogleAnalytics: GoogleAnalyticsDataAdapter
}