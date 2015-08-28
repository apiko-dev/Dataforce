class RawGraph
  constructor: (@curve, @data) ->

  getSeries: ->
    metadata = @curve.metadata
    metric = metadata.metric.name
    dimension = metadata.dimension.name

    min = false
    max = false
    data = @data.map (doc) ->
      metricValue = doc[metric]
      if min is false or metricValue < min then min = metricValue
      if max is false or metricValue > max then max = metricValue
      [doc[dimension], metricValue]

    if @curve.normalize
      data.forEach (point) -> point[1] = point[1] / max

    console.log data
    return data


_.extend App.SalesForce, {
  RawGraph: RawGraph
}