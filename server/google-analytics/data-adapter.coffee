class GASeriesMerger
  ###
    Divides a collection into several parts with chunkSize length
  ###
  _chunk: (collection, chunkSize) ->
    if !collection or _.isNaN(parseInt(chunkSize, 10))
      return []
    _.toArray _.groupBy collection, (iterator, index) ->
      Math.floor index / parseInt(chunkSize, 10)

  ###
    arguments: [[27],[22],[24],[10],[11]], [[40],[45],[42],[63],[57]]
  ###
  constructor: (@series1, @series2) ->

    ###
      return [[27,40],[22,45],[24,42],[10,63],[11,57]]
    ###
  getSeries: ->
    [{data: _.sortBy(App._helpers._chunk(_.flatten(_.zip(@series1, @series2)), 2), (el) -> el[0])}]


class GoogleAnalyticsDataAdapter
  constructor: (@chartQuery, @json) ->
    @setAxisNames()

  @_axisNames: []

  _getXAxisName: ->
    gaDimensionsList = JSON.parse Assets.getText "ga/ga-dimensions-list.json"
    dimensions = @chartQuery.dimensions
    _.find(gaDimensionsList, (dimension) ->
      dimension.key is dimensions)?.value or ""

  _getYAxisesNames: ->
    gaMetricsList = JSON.parse Assets.getText "ga/ga-metrics-list.json"
    metricsList = @chartQuery.metrics.split ","
    axisesCount = metricsList.length
    yAxisesNames = (_.find(gaMetricsList, (metric) -> metric.key is metricsList[i])?.value or "" for i in [0..axisesCount])

  setAxisNames: ->
    @_axisNames =
      x: @_getXAxisName()
      y: @_getYAxisesNames()

  getSeries: ->
    # example series [{data: [119, 56], name: "abc"}, {data: [100, 23], name: "def"}]
    series = []
    axisNames = @_axisNames
    rows = @json.result.rows
    axisesCount = rows[0].length - 1

    #todo: this piece of code is hard to maintain
    #todo: @vlad: please refactor it
    series = ({
    data: _.map rows, (row) -> (parseInt element for element, index in row when index is (axisIndex + 1))
    name: axisNames.y[axisIndex]
    } for axisIndex in [0..(axisesCount - 1)])

    if @chartQuery.mergeMetrics
      seriesMerger = new GASeriesMerger series[0].data, series[1].data
      seriesMerger.getSeries()
    else
      series

_.extend App.DataAdapters, {
  GoogleAnalytics: GoogleAnalyticsDataAdapter
}