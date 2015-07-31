Template.CurveTypeChooser.events
  'click .curve-type-chooser .btn': (event, tmpl) ->
    chosenCurveType = tmpl.$(event.target).data 'type'