Template.SignIn.onCreated ->
  @errorMessage = new ReactiveVar(false)


Template.SignIn.helpers
  errorMessage: -> Template.instance().errorMessage.get()


Template.SignIn.events
  'submit form': (event, tmpl) ->
    event.preventDefault()
    email = tmpl.$('#emailInput').val()
    password = tmpl.$('#passwordInput').val()

    Meteor.loginWithPassword email, password, (error) ->
      if error
        tmpl.errorMessage.set error.reason
      else
        Router.go 'dashboard'
