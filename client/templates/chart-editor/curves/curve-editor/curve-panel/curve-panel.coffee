Template.CurvePanel.onRendered ->
  @panel = @$(".panel")
  $('[data-toggle="tooltip"]').tooltip()

Template.CurvePanel.events
  "click .remove-curve": (e, t) ->
    t.panel.remove()