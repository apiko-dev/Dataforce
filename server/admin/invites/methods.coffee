Meteor.methods
  getEmailByInviteId: (inviteId) ->
    check inviteId, App.checkers.MongoId
    invite = Invites.findOne({_id: inviteId})
    unless invite then throw new Meteor.Error('404', 'Invite doesn\'t exists')
    return invite.email