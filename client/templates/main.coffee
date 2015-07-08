Template.main.helpers counter: ->
  Session.get 'counter'
Template.main.events 'click button': ->
  Meteor.call "getGAaccounts", Meteor.userId()