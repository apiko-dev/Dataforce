Template.ConnectorFilter.helpers
#todo: this should be moved into database
  connectors: -> [
    {_id: 'SF', name: 'SalesForce', caption: 'SF', style: 'info'}
    {_id: 'GA', name: 'Google Analytics', caption: 'GA', style: 'danger'}
    {_id: 'ZD', name: 'Zendesk', caption: 'ZD', style: 'success'}
  ]
