#some overlay util methods

class App.Dataforce.Adapter
  @_months: ["January", "February", "March", "April", "May", "June", "July", "August", "September", "October",
             "November", "December"]

  @_yearMergeIterate: (dimensionValue) -> new Date(dimensionValue).getFullYear()

  @_monthMergeIterate: (dimensionValue) ->
    monthNumber = new Date(dimensionValue).getMonth()
    App.Dataforce.Adapter._months[monthNumber]

  @_dayMergeIterate: (dimensionValue) -> new Date(dimensionValue).getDate()

  @_merge: (series, mergeIterate) ->
    reduceIterate = (memo, data) ->
      memoKey = mergeIterate(data[0])
      memo[memoKey] ?= 0
      memo[memoKey] += data[1]
      return memo

    _.reduce series, reduceIterate, {}


  @_zipMergedData: (dimensionMergedSeries, metricMergedSeries) ->
    allKeys = _.extend {}, dimensionMergedSeries
    _.extend allKeys, metricMergedSeries

    _.each allKeys, (value, key) ->
      x = dimensionMergedSeries[key]
      y = metricMergedSeries[key]
      x ?= 0
      y ?= 0
      allKeys[key] = [x, y]

    Object.keys(allKeys)
    .map((key) -> allKeys[key])
    .sort (pointA, pointB) -> pointA[0] - pointB[0]


  @generateCurveSeries: (dataforceCurve) ->
    dimensionSeries = Series.findOne {curveId: dataforceCurve.metadata.dimension}
    metricSeries = Series.findOne {curveId: dataforceCurve.metadata.metric}

    #merge iterate dispatching
    deltaName = dataforceCurve.metadata.delta.name
    currentMergeIterate = @["_#{deltaName}MergeIterate"]

    unless currentMergeIterate then throw new Meteor.Error("Unknown delta: #{deltaName}")

    metricMergedSeries = @_merge metricSeries.data, currentMergeIterate
    dimensionMergedSeries = @_merge dimensionSeries.data, currentMergeIterate

    @_zipMergedData(dimensionMergedSeries, metricMergedSeries)


