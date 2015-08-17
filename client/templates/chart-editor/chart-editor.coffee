Template.ChartEditor.onCreated ->
  @updateChartName = =>
    chartName = @$('.chart-name').val()
    if chartName isnt @data.name
      Charts.update {_id: @data._id}, $set: {name: chartName}


Template.ChartEditor.events
  'keyup .chart-name': (event, tmpl) ->
    if event.which is 13 #pressed enter
      tmpl.updateChartName()

  'blur .chart-name': (event, tmpl) ->
    tmpl.updateChartName()
