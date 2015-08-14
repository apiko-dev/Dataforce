Template.AxisChooser.onRendered ->
  @curve = new ReactiveVar false

Template.AxisChooser.onRendered ->
  tmpl = @
  curveId = tmpl.get 'newCurveId'
  Tracker.autorun ->
    tmpl.curve.set Curves.findOne {_id: curveId}


Template.AxisChooser.helpers
  xAxisInfo: ->
    if curve = Template.instance().curve?.get()
      "#{curve.source} -> #{curve.metadata?.entityName} -> #{curve.metadata?.metric or ''}"

  yAxisInfo: ->
    if curve = Template.instance().curve?.get()
      "#{curve.source} -> #{curve.metadata?.entityName} -> #{curve.metadata?.dimension or ''}"