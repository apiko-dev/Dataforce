#todo finish this transformer
class RawGraph
  constructor: (@metadata, @data) ->

  getSeries: () ->
    metric = @metadata.metric.name
    dimension = @metadata.dimension.name

    @data.map (doc) -> [doc[dimension], doc[metric]]

_.extend App.SalesForce, {
  RawGraph: RawGraph
}