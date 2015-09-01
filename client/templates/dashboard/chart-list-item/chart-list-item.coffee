Template.ChartListItem.events
  'click .remove-chart-button': (event, tmpl) ->
    Charts.remove {_id: tmpl.data._id}, App.handleError()

  'click .edit-chart-button': (event, tmpl) ->
    Router.go 'existingChartEditor', {chartId: tmpl.data._id}

  'click .open-chart-viewer-button': (event, tmpl) ->
    Router.go 'chartViewer', {chartId: tmpl.data._id}
