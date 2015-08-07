Template.SignStatus.events
  'click .logout-button': (event, tmpl) ->
    event.preventDefault()
    Meteor.logout()
    Router.go 'signIn'