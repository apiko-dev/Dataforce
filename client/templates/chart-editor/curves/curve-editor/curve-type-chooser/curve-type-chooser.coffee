Template.CurveTypeChooser.events
  'click .curve-type-chooser .btn': (event, tmpl) ->
    chosenCurveType = $(event.target).data('type')