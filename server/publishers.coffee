compositeCurves = [
  {
    find: (chart) -> Curves.find {chartId: chart._id}
  }
  {
    find: (chart) -> Series.find {chartId: chart._id}
  }
]


#one chart
Meteor.publishComposite 'chart', (chartId) ->
  check chartId, App.checkers.MongoId
  userId = @userId

  find: ->
    chartsCursor = Charts.find {_id: chartId}
    #check owner
    if chartsCursor.count() > 0 and chartsCursor.fetch()[0].userId isnt userId
      @error new Meteor.Error('403', 'Access denied')
    else
      chartsCursor

  children: compositeCurves


#all user's charts
Meteor.publishComposite 'userCharts', ->
  userId = @userId

  find: -> Charts.find {userId: userId}
  children: compositeCurves


Meteor.publish 'authStatus', -> Connectors.find {userId: @userId}, fields: {tokens: 0}
