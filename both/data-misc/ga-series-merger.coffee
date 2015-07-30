class GASeriesMerger
  ###
    arguments: [[27],[22],[24],[10],[11]], [[40],[45],[42],[63],[57]]
  ###
  constructor: (@series1, @series2) ->

  ###
    return [[27,40],[22,45],[24,42],[10,63],[11,57]]
  ###
  getSeries: ->
    App.DataMisc.SeriesDataWrapper.wrap _.sortBy(App.Functions._chunk(_.flatten(_.zip(@series1, @series2)), 2), (el) -> el[0])


_.extend App.DataMisc, {
  GASeriesMerger: GASeriesMerger
}