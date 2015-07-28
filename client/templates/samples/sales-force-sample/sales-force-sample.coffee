Template.SalesForceSample.onCreated ->


Template.SalesForceSample.helpers
  authUrl: ->
    App.DataAdapters.SalesForce::getAuthUrl()