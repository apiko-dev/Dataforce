#global application's scope
@App =
  GoogleAnalytics: {}
  SalesForce:
    isNumberType: (type) -> type in ['int', 'double', 'currency', 'percent']

  isAdmin: (userId) ->
    userId = userId or Meteor.userId()
    Roles.userIsInRole userId, ['admin']

#check user's permissions to access specified document
  allowAccess: (document, userId) ->
    userId ?= Meteor.userId()
    userId is document.userId and Roles.userIsInRole userId, ['admin', 'tester']


@ConnectorNames =
  GoogleAnalytics: 'Google Analytics'
  Salesforce: 'Salesforce'
  Dataforce: 'Dataforce'
  Zendesk: 'Zendesk'