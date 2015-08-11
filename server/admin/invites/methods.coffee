Meteor.methods
  getEmailByInviteId: (inviteId) ->
    check inviteId, App.checkers.MongoId
    invite = Invites.findOne({_id: inviteId})
    unless invite then throw new Meteor.Error('404', 'Invite doesn\'t exists')
    return invite.email

  createUserByInvite: (user) ->
    check user, {
      email: String
      password: String
    }

    getInvite = (userEmail) -> Invites.findOne {email: userEmail}
    validateInvite = (userEmail) ->
      invite = getInvite(userEmail)
      currentTime = new Date().getTime()
      isInviteValid = invite and currentTime < invite.expireDate.getTime()
      if isInviteValid then invite else false

    invite = validateInvite(user.email)
    if invite
      id = Accounts.createUser user
      Invites.update {_id: invite._id}, {$set: {accountCreated: true}}

      Roles.addUsersToRoles id, ['tester']
    else
      throw new Meteor.Error(403, 'Your invite is expired or doesn\'t exist')