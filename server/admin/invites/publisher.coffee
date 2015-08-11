Meteor.publish 'invites', () ->
  if App.isAdmin(@userId)
    return Invites.find({})
  else
    @stop()