Template.ConnectorFilter.onCreated ->
  @subscribe('authStatus')


Template.ConnectorFilter.helpers
  connectors: -> [
    {name: ConnectorNames.Salesforce, caption: 'SF', style: 'info'}
    {name: ConnectorNames.GoogleAnalytics, caption: 'GA', style: 'danger'}
    {name: ConnectorNames.Zendesk, caption: 'ZD', style: 'success'}
  ].filter (connector) -> !!Connectors.findOne {name: connector.name} #show only services user logged in
