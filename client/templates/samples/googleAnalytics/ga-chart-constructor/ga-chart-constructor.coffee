Template.gaChartConstructor.onCreated ->
  @gaAccounts = new ReactiveVar []
  @additionalAxises = new ReactiveVar []

Template.gaChartConstructor.onRendered ->
  initDatepicker = =>
    @.$('#gaDatepicker').datepicker
      format: "yyyy-mm-dd",
      startDate: gaFoundingData = "2007-12-01",
      autoclose: true,
      orientation: "top right"
      todayHighlight: true

  initProfilesSelect = =>
    @.$("#profile-selector").select2()

  initAuthButton = =>
    Meteor.call "GA.generateAuthUrl", (err, result) ->
      @.$("#auth-with-ga").attr "href", result

  initDatepicker()
  initProfilesSelect()
  initAuthButton()

Template.gaChartConstructor.helpers
  GAaccounts: ->
    Template.instance().gaAccounts.get()

  metricsList: ->
    gaMetricsList

  dimensionsList: ->
    gaDimensionsList

  additionalAxises: ->
    Template.instance().additionalAxises.get()

  addMoreYAxis: ->
    Session.get("addMoreYAxis") or false

  selected: (event, suggestion, datasetName) ->
    console.log event, suggestion, datasetName


Template.gaChartConstructor.events
  'click #getUAlist': (e, t) ->
    Meteor.call "GA.getAccounts", (err, result) ->
      t.gaAccounts.set result

  'click #one-more-axis': (e, t) ->
    t.additionalAxises.set [0..t.additionalAxises.get().length]
