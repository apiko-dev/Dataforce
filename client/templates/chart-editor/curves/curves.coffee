Template.Curves.onCreated ->
  @newCurveId = new ReactiveVar(null)

  
Template.Curves.helpers
  curves: -> Curves.find {chartId: @_id}


Template.Curves.events
  'click .new-curve-button': (event, tmpl) ->
    Curves.insert {
      name: 'New curve'
      chartId: @_id
    }, App.handleError (id) ->
      tmpl.newCurveId.set(id)