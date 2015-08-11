Template.CreateInvite.onRendered ->
  @expireDateInput = @$('.expire-date-input')
  @expireDateInput.datepicker {}

  initialDate = moment().add(1, 'month').toDate() #current date + 1 month
  @resetExpireDate = => @expireDateInput.datepicker 'setDate', initialDate

  @resetExpireDate()


Template.CreateInvite.events
  'click .send-invite-button': (event, tmpl) ->
    createdInvite =
      email: tmpl.$('.invite-email-input').val()
      expireDate: tmpl.expireDateInput.datepicker 'getDate'

    Meteor.call 'sendInviteViaEmail', createdInvite, App.handleError () ->
      tmpl.$('.invite-email-input').val('') #clear fields
      tmpl.resetExpireDate()