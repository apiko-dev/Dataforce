class SeriesDataWrapper
  @wrap: (@dataArray) ->
    [{data: @dataArray}]

_.extend App.DataMisc, {
  SeriesDataWrapper: SeriesDataWrapper
}