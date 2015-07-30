Template.CurvePanel.onRendered ->
  @panel = @$(".panel")

Template.CurvePanel.events
  "click .remove-curve": (e, t) ->
    t.panel.remove()