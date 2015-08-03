Template.Connectors.helpers
  availableConnectors: -> [
    {
      name: 'Salesforce',
      authUrl: Meteor.settings.public.SalesForce.authUrl,
      logoutUrl: 'todo:'
    }
#    todo: add ga and zd
  ]