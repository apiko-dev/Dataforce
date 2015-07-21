class SalesForceDataAdapter
  authUrl: '/oauth2/sales-force'
  constructor: (@dataTransformer) ->


_.extend App.DataAdapters, {
  SalesForce: SalesForceDataAdapter
}