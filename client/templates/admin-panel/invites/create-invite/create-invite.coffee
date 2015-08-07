Template.CreateInvite.events
  'click .send-invite-button': (event, tmpl) ->
    createdInvite =
      email: tmpl.$('.invite-email-input').val()
      expireDate: moment(tmpl.$('.expire-date-input').val()).toDate()

    Invites.insert createdInvite

    tmpl.$('.invite-email-input').val('')
    tmpl.$('.expire-date-input').val('')