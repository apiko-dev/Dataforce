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
    {
      name: ConnectorNames.GoogleAnalytics
      authUrl: ReactiveMethod.call 'GA.generateAuthUrl'
      logoutMethod: 'GA.logout'
    }
  ]

  hasAuth: -> !!Connectors.findOne name: @name


Template.Connectors.events
  'click .revoke-access-button': (event, tmpl) ->
    revokeMethod = tmpl.$(event.target).attr('data-logout-method')
    console.log 'method: ', revokeMethod
    if confirm('Are you sure?\nAll your charts related to this connector will be deleted.')
      Meteor.call revokeMethod, App.handleError()