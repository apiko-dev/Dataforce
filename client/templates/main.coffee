Template.main.rendered = ->
  $('.input-daterange').datepicker
    format: "yyyy-mm-dd",
    startDate: "2007-12-01",
    autoclose: true,
    orientation: "top right"
    todayHighlight: true

Template.main.helpers
  GAaccounts: ->
    Session.get "GAaccounts"

  UAProfileData: ->
    Session.get "UAProfileData"

  arrayify: (obj) ->
    _.map obj, (val, key) ->
      console.log val, key
      name: key
      value: val

  stringify: (obj) ->
    JSON.stringify obj

Template.main.events
  'click #getUAlist': ->
    Meteor.call "getGAaccounts", Meteor.userId(), (err, result) ->
      console.log result
      Session.set "GAaccounts", result.result

  'click #getData': (e, t) ->
    query =
      profileId: t.$("#profile-selector").val()
      from: t.$("#datepicker input").eq(0).val()
      to: t.$("#datepicker input").eq(1).val()

    Meteor.call "getUAProfileData", query, (err, result) ->
      console.log result.result.totalsForAllResults
      Session.set "UAProfileData", result.result.totalsForAllResults