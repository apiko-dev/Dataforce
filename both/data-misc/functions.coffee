_.extend App.Functions, {
  _withoutLast: (arr) ->
    _.reject arr, (num, i) ->
      (arr.length - 1) is i

  _chunk: (collection, chunkSize) ->
    if !collection or _.isNaN(parseInt(chunkSize, 10))
      return []
    _.toArray _.groupBy collection, (iterator, index) ->
      Math.floor index / parseInt(chunkSize, 10)
}