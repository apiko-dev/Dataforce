Template.Connectors.helpers
  availableConnectors: -> [
    {
      name: 'Salesforce'
      authUrl: Meteor.settings.public.SalesForce.authUrl
      logoutMethod: 'todo:'
    }
    {
      name: 'Google Analytics'
      authUrl: ReactiveMethod.call 'GA.generateAuthUrl'
      logoutMethod: 'GA.logout'
    }
  ]