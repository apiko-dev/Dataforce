Meteor.publish 'userCharts', -> Charts.find {userId: @userId}

Meteor.publish 'userChart', (chartId) ->
  check chartId, App.checkers.MongoId

  cursor = Charts.find {_id: chartId}

  if cursor.fetch()[0].userId is @userId
    return cursor
  else
    @error new Meteor.Error('Access denied')