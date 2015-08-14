Template.CurveEditor.onCreated ->
  @axisX = new ReactiveVar {type: 'x'}
  @axisY = new ReactiveVar {type: 'y'}


Template.CurveEditor.helpers
  curvesList: [
    {caption: 'Line', type: 'line'}
    {caption: 'Column', type: 'line'}
    {caption: 'Area', type: 'area'}
    {caption: 'Pie', type: 'pie'}
  ]

  sourcePickerModalConfig: ->
    tmpl = Template.instance()
    context: {}
    windowClass: 'dragable-big'
    backdrop: true
    onInitialize: (instance) ->
      tmpl.chartSourcePicker = instance


Template.CurveEditor.events
  'click .remove-curve': (event, tmpl) ->
    Curves.remove _id: tmpl.data._id

    tmpl.chartId = tmpl.get 'createdChartId'
    tmpl.get('newCurves').set Curves.find(chartId: tmpl.chartId)

  'keyup .curve-title': (event, tmpl) ->
    curveId = tmpl.data._id
    curveName = tmpl.$(event.target).val()

    console.log curveId, curveName

    Curves.update {_id: curveId}, {
      $set:
        name: curveName
    }

  'click .axis-chooser': (event, tmpl) ->
    chosenAxis = getChosenAxis(event, tmpl)

    if chosenAxis is 'x'
      tmpl.chartSourcePicker.show axis: tmpl.axisX
    else
      tmpl.chartSourcePicker.show axis: tmpl.axisY

getChosenAxis = (event, tmpl) ->
  clickedOnChild = event.target.tagName is 'SPAN'
  if clickedOnChild
    tmpl.$(event.target).parent().data 'axis'
  else
    tmpl.$(event.target).data 'axis'