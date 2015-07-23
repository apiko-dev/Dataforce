Template.ChartListItem.events
  'click .remove-chart-button': (event, tmpl) ->
    Charts.remove {_id: tmpl.data._id}, App.handleError()
