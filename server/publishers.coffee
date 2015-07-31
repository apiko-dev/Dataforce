Meteor.publish 'userCharts', -> Charts.find {userId: @userId}


Meteor.publish 'userChart', (chartId) ->
  check chartId, App.checkers.MongoId

  cursor = Charts.find {_id: chartId}

  if cursor.fetch()[0].userId is @userId
    return cursor
  else
    @error new Meteor.Error('Access denied')


Meteor.publish 'authStatus', () -> ServiceCredentials.find {userId: @userId},
#  temporal solution for excluding fields (may be automated)
  fields:
    'salesforce.accessToken': 0
    'salesforce.instanceUrl': 0
    'salesforce.refreshToken': 0
    'googleAnalytics.access_token': 0
    'googleAnalytics.token_type': 0
    'googleAnalytics.id_token': 0
    'googleAnalytics.expiry_date': 0