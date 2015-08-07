Template.Invites.onCreated ->
  @subscribe('invites')

Template.Invites.helpers
  invites: -> Invites.find({})

