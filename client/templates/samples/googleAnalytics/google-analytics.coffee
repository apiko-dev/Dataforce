Template.googleAnalyticsSample.helpers
  stringify: (obj) ->
    JSON.stringify obj

Template.googleAnalyticsSample.events
  "click #ga-logout": (event, tmpl) ->
    console.log "loggin out from google analytics"
    Meteor.call "GA.logout"