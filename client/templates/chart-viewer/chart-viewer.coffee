Template.ChartViewer.events
  'click .edit-chart-button': (event, tmpl) ->
    Router.go 'existingChartEditor', {chartId: tmpl.data._id}