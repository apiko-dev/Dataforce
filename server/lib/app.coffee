#==== global application's object for server side ====


_App = {
  checkers:
    MongoId: Match.Where (id) ->
      check id, String
      return /[0-9a-zA-Z]{17}/.test(id)


    FilterModifier: Match.Where (x) ->
      check(x, String)
      return x in ['$gt', '$eq', '$lt', '$lte', '$gte', '$ne']


    ValueFunction: Match.Where (x) ->
      check(x, String)
      return x in ['sum', 'average', 'multiply']


    Filter: Match.Where (x) ->
      check x,
        field:
          name: String
          value: Match.Any
        modifier: _App.checkers.FilterModifier
      return true


    Chart: Match.Where (x) ->
      check x,
        table: String
        filters: [_App.checkers.Filter]
        valueFunction: _App.checkers.ValueFunction
        axis:
          metrics: String
          dimension: String
          dimension2: Match.OneOf String, null
      return true

#check user's permissions to access specified document
  checkPermissions: (document, userId) ->
    userId ?= Meteor.userId()
    if userId isnt document.userId or not Roles.userIsInRole userId, ['admin', 'tester']
      throw new Meteor.Error '401', 'Access denied by checkPermission'
}


_.extend App, _App

#IntercomSettings.userInfo = (user, info) ->
#  # add properties to the info object, for instance:
#  if user.services.google
#    info.email = user.services.google.email
#    info['name'] = user.services.google.given_name + ' ' + user.services.google.family_name