Template.CurvePanel.onRendered ->
  @panel = @$(".panel")
  $('[data-toggle="tooltip"]').tooltip()

Template.CurvePanel.events
  "click .remove-curve": (e, t) ->
    t.panel.slideUp 500, -> t.panel.remove()

    newCurves = t.get "newCurves"
    Meteor.setTimeout ->
      newCurves.set App.Functions._withoutLast newCurves.get()
    , 510
