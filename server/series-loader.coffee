Meteor.methods
  'loadSeries': (chartId) ->
    check chartId, String

    seriesLoader = new SeriesLoader(chartId)
    seriesLoader.getSeries()


class SeriesLoader
  constructor: (chartId) ->
    @userId = Charts.findOne(_id: chartId).userId
    @curves = Curves.find(chartId: chartId).fetch()

  getSeries: ->
    console.log 'getting the series...'
    for curve in @curves
      console.log curve
      switch curve.source
        when ConnectorNames.GoogleAnalytics
          console.log 'yay, google analytics'
          gadl = new GoogleAnalyticsDataLoader(curve.metadata, @userId)
          gada = new GoogleAnalyticsDataAdapter(curve, gadl.getJSON())
          gada.getSeries()

        when ConnectorNames.Salesforce
          []

        else
          []