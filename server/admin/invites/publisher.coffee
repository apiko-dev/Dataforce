Meteor.publish 'invites', () ->
  if App.isAdmin(@userId)
    return Invites.find({})
  else
    @stop()


#  if Roles.userIsInRole(@userId, ['tester'])
#    console.log 'should be checked'
