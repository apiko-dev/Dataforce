#recieves connector as context
Template.ConnectorEntity.onRendered ->
  @autorun =>
    data = Template.currentData()

Template.ConnectorEntity.helpers
  entities: -> [
    {name: 'Users'}
    {name: 'Accounts'}
    {name: 'Campaigns'}
    {name: 'Opportunities'}
  ]