Template.SignUp.onCreated ->
  @errorMessage = new ReactiveVar(false)
  @email = new ReactiveVar()

  Meteor.call 'getEmailByInviteId', @data.inviteId, (err, email) =>
    if err
      @errorMessage.set err.toString()
    else
      @email.set email

      
Template.SignUp.helpers
  errorMessage: -> Template.instance().errorMessage.get()
  email: -> Template.instance().email.get()


Template.SignUp.events
  'submit form': (event, tmpl) ->
    event.preventDefault()
    password = tmpl.$('#inputPassword').val()
    passwordRepeat = tmpl.$('#inputPasswordRepeat').val()

    if password isnt passwordRepeat
      tmpl.errorMessage.set 'Passwords should match'
      return

    if password.length < 8
      tmpl.errorMessage.set 'Password length should be 8 letters or more'
      return

    Accounts.createUser {
      email: tmpl.$('#inputEmail').val()
      password: password
    }, (error) ->
      if error
        tmpl.errorMessage.set error.reason
      else
        Router.go 'dashboard'