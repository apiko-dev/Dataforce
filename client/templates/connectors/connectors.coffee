Template.Connectors.onCreated ->
#subscribe on connectors' auth status
  @subscribe 'authStatus'


Template.Connectors.helpers
  availableConnectors: -> [
    {
      name: ConnectorNames.Salesforce
      authUrl: Meteor.settings.public.SalesForce.authUrl
      logoutMethod: 'sfRevokeAccess'
    }
#    {
#      name: ConnectorNames.GoogleAnalytics
#      authUrl: ReactiveMethod.call 'GA.generateAuthUrl'
#      logoutMethod: 'GA.logout'
#    }
  ]

  hasAuth: -> !!Connectors.findOne name: @name
  apiUsage: -> Connectors.findOne(name: @name).apiUsage


Template.Connectors.events
  'click .revoke-access-button': (event, tmpl) ->
    revokeMethod = tmpl.$(event.target).attr('data-logout-method')
    if confirm('Are you sure?\nAll your charts related to this connector will be deleted.')
      Meteor.call revokeMethod, App.handleError()

  'click .connect-connector': (event, tmpl) ->
    analytics.track 'Connected connector', {
      connectorName: tmpl.$(event.target).text()
    }