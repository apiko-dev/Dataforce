class SalesForceDataAdapter
  ###
    SF auth URL for OAuth2.0
  ###
  getAuthUrl: (userId) -> "/oauth2/sales-force/login/#{userId}"

  isNumberType: (type) -> type in ['int', 'double', 'currency', 'percent']

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