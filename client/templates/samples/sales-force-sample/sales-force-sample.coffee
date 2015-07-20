Template.SalesForceSample.onCreated ->
  @getCredentials = =>
    accessToken: @data.accessToken
    instanceUrl: @data.instanceUrl