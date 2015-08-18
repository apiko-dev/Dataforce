Template.Curves.onCreated ->
#stores faded in curves and prevents self collapsing after collection update
  @collapsedCurves = new Mongo.Collection null

  @curveTypes = [
    {caption: 'Line', type: 'line', icon: 'fa-line-chart'}
    {caption: 'Column', type: 'column', icon: 'fa-bar-chart'}
    {caption: 'Area', type: 'area', icon: 'fa-area-chart'}
    {caption: 'Pie', type: 'pie', icon: 'fa-pie-chart'}
  ]


Template.Curves.helpers
  curves: -> Curves.find {chartId: @_id}


Template.Curves.events
  'click .new-curve-button': (event, tmpl) ->
    Curves.insert {
      name: 'New curve'
      chartId: @_id
    }, App.handleError (id) ->
      tmpl.collapsedCurves.insert {curveId: id}