class App.SalesForce.RawGraph
  constructor: (@curve, @data) ->

  getData: ->
    metadata = @curve.metadata
    metric = metadata.metric.name
    dimension = metadata.dimension.name

    isDateDimension = metadata.dimension.type is 'date'

    mappedData = @data.map (doc) ->
      d = new Date(doc[dimension])
      dimensionValue = if isDateDimension then d.valueOf() else doc[dimension]
      [dimensionValue, doc[metric]]

    #sort by date if dimension has type date
    unless isDateDimension
      mappedData
    else
#      todo fix sorting
      console.log 'recalculated'
      sorted = mappedData.sort (p1, p2) -> p1[0] > p2[0]
      #      sorted.forEach (p, i) ->
      #        next = sorted[i + 1]?[0]
      #        if next
      #          if p[0] > next then console.log 'not sorted ', i
      return sorted