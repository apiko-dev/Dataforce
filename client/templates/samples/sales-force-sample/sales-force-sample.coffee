Template.SalesForceSample.onCreated ->
  @getCredentials = =>
    accessToken: @data.accessToken
    instanceUrl: @data.instanceUrl


Template.SalesForceSample.helpers
  authUrl: -> App.DataAdapters.SalesForce.authUrl