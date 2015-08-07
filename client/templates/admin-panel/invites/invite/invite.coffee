Template.Invite.onRendered ->
  @$('.expire-date-input').val moment(@data.expireDate).format('mm/dd/yyyy')

Template.Invite.events
  'click .remove-invite-button': (event, tmpl) ->
    if confirm('Are you sure?')
      Invites.remove _id: tmpl.data._id
