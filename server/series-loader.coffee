Meteor.methods
  'loadSeries': (chartDescriptions...) ->
    check chartDescriptions, Array

    seriesLoader = new SeriesLoader(chartDescriptions...)
    seriesLoader.getSeries()


class SeriesLoader
  constructor: (chartDescriptions...) ->
    console.log chartDescriptions

  getSeries: ->
    console.log 'getting the series'
    [name: 'seriesName', data: [1, 2, 3]]