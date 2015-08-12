Template.AxisChooser.helpers
  xAxisChosenDate: ->
    xData = Session.get 'axisVarX'
    if not xData
      ''
    else
      xData.connectorId + '\n' + xData.entityName + '\n' + xData.fieldName

  yAxisChosenDate: ->
    yData = Session.get 'axisVarY'
    if not yData
      ''
    else
      yData.connectorId + '\n' + yData.entityName + '\n' + yData.fieldName
Template.AxisChooser.events
  'click .axis-chooser': (event, tmpl) ->
    chosenAxis = tmpl.$(event.target).data 'axis'