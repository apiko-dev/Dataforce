Template.AxisChooser.events
  'click .axis-chooser': (event, tmpl) ->
    chosenAxis = tmpl.$(event.target).data 'axis'