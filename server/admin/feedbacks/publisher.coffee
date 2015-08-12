Meteor.publish 'feedbacks', () ->
  if App.isAdmin(@userId)
    return Feedbacks.find({})
  else
    @stop()