Template.googleAnalyticsSample.helpers
  stringify: (obj) ->
    JSON.stringify obj

Template.googleAnalyticsSample.events
  "click #ga-logout": -> Meteor.call "GA.logout"
  "click #ga-get-auth-state": -> Tracker.autorun -> console.log ReactiveMethod.call "GA.isAuthenticated"