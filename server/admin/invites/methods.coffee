Meteor.methods
  sendInviteViaEmail: (invite) ->
    check invite, {
#todo put email check here
      email: String,
      expireDate: Date
    }

    #check user permission
    if Roles.userIsInRole @userId, 'admin'
      inviteId = Invites.insert invite
      if invite
        Email.send
          to: invite.email
          from: "Mykola @ getDataforce <mykola@getdataforce.com>"
          subject: "Welcome to the Dataforce Alpha!"
          html: Handlebars.templates['invite-email'](
            urlWithToken: "#{process.env.ROOT_URL}sign-up/#{inviteId}"
          )
      else throw new Meteor.Error '404', 'Invite not found'


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

    validateInvite = (userEmail) ->
      invite = Invites.findOne {email: userEmail}
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