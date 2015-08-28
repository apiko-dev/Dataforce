class RawGraph
  constructor: (@curve, @data) ->

  getData: ->
    metadata = @curve.metadata
    metric = metadata.metric.name
    dimension = metadata.dimension.name
    @data.map (doc) -> [doc[dimension], doc[metric]]


_.extend App.SalesForce, {
  RawGraph: RawGraph
}