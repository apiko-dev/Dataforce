#some overlay util methods

class App.Dataforce.Adapter
  @_months: ["January", "February", "March", "April", "May", "June", "July", "August", "September", "October",
             "November", "December"]

  @_yearMergeIterate: (dimensionValue) -> new Date(dimensionValue).getFullYear()

  @_monthMergeIterate: (dimensionValue) ->
    monthNumber = new Date(dimensionValue).getMonth()
    @_months[monthNumber]

  @_dayMergeIterate: (dimensionValue) -> new Date(dimensionValue).getDate()

  @_merge: (series, mergeIterate) ->
    reduceIterate = (memo, point) ->
      memoKey = mergeIterate(point.x)
      memo[memoKey] ?= 0
      memo[memoKey] += point.y
      return memo

    _.reduce series, reduceIterate, {}


  @_zipMergedData: (dimensionMergedSeries, metricMergedSeries) ->
    allKeys = _.extend {}, dimensionMergedSeries
    _.extend allKeys, metricMergedSeries

    Object.keys(allKeys).map (key) ->
      x = dimensionMergedSeries[key]
      y = metricMergedSeries[key]
      x ?= 0
      y ?= 0
      {x: x, y: y, mergeValue: key}
    .sort (pointA, pointB) -> pointA.x - pointB.x


  @generateCurveSeries: (dataforceCurve) ->
    dimensionSeries = Series.findOne {curveId: dataforceCurve.metadata.dimension}
    metricSeries = Series.findOne {curveId: dataforceCurve.metadata.metric}

    if dimensionSeries and metricSeries
#merge iterate dispatching
      deltaName = dataforceCurve.metadata.delta.name
      currentMergeIterate = @["_#{deltaName}MergeIterate"]
      unless currentMergeIterate then throw new Meteor.Error("Unknown delta: #{deltaName}")
      #bind context that was lost after dispatching
      currentMergeIterate = _.bind currentMergeIterate, @

      metricMergedSeries = @_merge metricSeries.data, currentMergeIterate
      dimensionMergedSeries = @_merge dimensionSeries.data, currentMergeIterate

      @_zipMergedData(dimensionMergedSeries, metricMergedSeries)


