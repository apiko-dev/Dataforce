disableExpiredInvitesTask = ->
  currentDate = new Date()
  console.log "cron_job:#{currentDate.toString()}: disable users with expired invites"

  expiredInvites = Invites.find {expireDate: {$lt: currentDate}}
  emails = expiredInvites.fetch().map (invite) -> invite.email
  users = Meteor.users.find({'emails.0.address': {$in: emails}}).fetch()
  Roles.removeUsersFromRoles users, 'tester'


new Meteor.Cron({
  events: {
    "0 * * * *": disableExpiredInvitesTask
  }
});