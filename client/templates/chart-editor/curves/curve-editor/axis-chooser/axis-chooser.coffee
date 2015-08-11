Template.AxisChooser.helpers
  xAxisChosenDate: ->
    xData = Session.get 'axisVarX'
    if xData is null
      ''
    else
      xData.connectorId + '\n' + xData.entityName + '\n' + xData.fieldName

  yAxisChosenDate: ->
    yData = Session.get 'axisVarY'
    if yData is null
      ''
    else
      yData.connectorId + '\n' + yData.entityName + '\n' + yData.fieldName
Template.AxisChooser.events
  'click .axis-chooser': (event, tmpl) ->
    chosenAxis = tmpl.$(event.target).data 'axis'