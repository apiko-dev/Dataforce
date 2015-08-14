Meteor.methods
  'loadSeries': (curveIds...) ->
    check curveIds, Array

    seriesLoader = new SeriesLoader(curveIds...)
    seriesLoader.getSeries()


class SeriesLoader
  constructor: (curveIds...) ->
    console.log curveIds

  getSeries: ->
    console.log 'getting the series'
    [name: 'seriesName', data: [1, 2, 3]]