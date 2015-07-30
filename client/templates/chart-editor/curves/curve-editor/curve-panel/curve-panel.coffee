Template.CurvePanel.onRendered ->
  @panel = @$(".panel")
  $('[data-toggle="tooltip"]').tooltip()

Template.CurvePanel.events
#todo: @vlad, please follow next naming convention event handler's params should be named as 'event' and 'tmpl'
  "click .remove-curve": (event, tmpl) ->
    tmpl.panel.slideUp 500, -> tmpl.panel.remove()

    newCurves = tmpl.get "newCurves"
    Meteor.setTimeout ->
      newCurves.set App.Functions._withoutLast newCurves.get()
    , 510
