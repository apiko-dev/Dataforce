class SalesForceDataAdapter
  ###
    SF auth URL for OAuth2.0
  ###
  authUrl: '/oauth2/sales-force'

  ###
    dataTransformer - any class from data transformer's that can work with table data
  ###
  constructor: (@dataTransformer) ->


  getHighchartSeries: (chart, onDataReady) ->
    Meteor.call 'sfGetTableData', chart.table, chart.filters, (err, tableData) =>
      series = new @dataTransformer(chart, tableData)
      convertedSeries = series.getConvertedSeriesForHighchart()
      onDataReady(convertedSeries)


_.extend App.DataAdapters, {
  SalesForce: SalesForceDataAdapter
}