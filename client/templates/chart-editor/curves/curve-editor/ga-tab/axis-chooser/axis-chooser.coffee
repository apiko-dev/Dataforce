Template.AxisChooser.onRendered ->
  @curveId = @get 'newCurveId'

Template.AxisChooser.helpers
  xAxis: ->
    tmpl = Template.instance()
    Curves.findOne {_id: tmpl.curveId}

  yAxis: ->
    tmpl = Template.instance()
    Curves.findOne {_id: tmpl.curveId}