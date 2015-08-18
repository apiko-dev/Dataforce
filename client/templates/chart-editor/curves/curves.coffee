Template.Curves.onCreated ->
#prevents self collapsing after curve update
#stores collapsed curves
  @collapsedCurves = new Mongo.Collection null


Template.Curves.helpers
  curves: -> Curves.find {chartId: @_id}


Template.Curves.events
  'click .new-curve-button': (event, tmpl) ->
    Curves.insert {
      name: 'New curve'
      chartId: @_id
    }, App.handleError (id) ->
      tmpl.collapsedCurves.insert {curveId: id}