Meteor.methods
  'loadSeries': (chartId) ->
    check chartId, String

    seriesLoader = new SeriesLoader(chartId)
    seriesLoader.getSeries()

###
  All you need to know to get highcharts series can be obtained knowing only chart id
  It's very efficient: send id from client and get the raw data array from server
  this verbose comments are just thoughts

  @trsdln: nice idea, I approve
###
class SeriesLoader
  constructor: (chartId) ->
    @userId = Charts.findOne(_id: chartId).userId
    @curves = Curves.find(chartId: chartId).fetch()

  getSeries: ->
#    todo: remove redundant console logs
    console.log 'getting the series...'
    for curve in @curves
      console.log curve
      ###
        Depending on curve source we run specific Data Adapters to get the right data
      ###
      switch curve.source
        when ConnectorNames.GoogleAnalytics
          console.log 'yay, google analytics is here'
          gadl = new GoogleAnalyticsDataLoader(curve.metadata, @userId)
          gada = new GoogleAnalyticsDataAdapter(curve, gadl.getJSON())
          gada.getSeries()

        when ConnectorNames.Salesforce
#          todo finish it
          []
        when ConnectorNames.Dataforce
#          todo finish it
          []
        else
#otherwise client got the error
          throw new Meteor.Error('404', 'We don\'t support this type of connector')