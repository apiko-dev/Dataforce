Template.Invite.onRendered ->
  @$('.expire-date-input').datepicker {}
  @$('.expire-date-input').datepicker 'setDate', @data.expireDate


Template.Invite.events
  'change .expire-date-input': (event, tmpl) ->
    expireMoment = tmpl.$('.expire-date-input').datepicker 'getDate'
    Invites.update {_id: tmpl.data._id}, {$set: {expireDate: expireMoment}}


  'click .remove-invite-button': (event, tmpl) ->
    if confirm('Are you sure?')
      Invites.remove _id: tmpl.data._id
