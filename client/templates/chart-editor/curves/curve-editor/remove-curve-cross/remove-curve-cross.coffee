Template.RemoveCurveCross.onRendered ->
  @panel = @$(".panel")
  $('[data-toggle="tooltip"]').tooltip()

Template.RemoveCurveCross.events
  "click .remove-curve": (event, tmpl) ->
    tmpl.panel.slideUp 500, -> tmpl.panel.remove()

    newCurves = tmpl.get "newCurves"
    Meteor.setTimeout ->
      newCurves.set App.Functions._withoutLast newCurves.get()
    , 510
