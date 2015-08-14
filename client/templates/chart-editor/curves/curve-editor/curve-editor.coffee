Template.CurveEditor.helpers
  curvesList: [
    {caption: 'Line', type: 'line'}
    {caption: 'Column', type: 'line'}
    {caption: 'Area', type: 'area'}
    {caption: 'Pie', type: 'pie'}
  ]
  editorTabs: [
    {connector: ConnectorNames.Salesforce, iconUrl: '/connectors/sf-small-logo.png'}
    {connector: ConnectorNames.GoogleAnalytics, iconUrl: '/connectors/ga-small-logo.png'}
    {connector: ConnectorNames.Dataforce, iconUrl: '/connectors/df-small-logo.png'}
  ]

  sourcePickerModalConfig: ->
    tmpl = Template.instance()
    context: {}
    windowClass: 'dragable-big'
    backdrop: true
    onInitialize: (instance) ->
      tmpl.chartSourcePicker = instance


Template.CurveEditor.events
  'click .remove-curve-button': (event, tmpl) ->
    Curves.remove _id: tmpl.data._id

    tmpl.chartId = tmpl.get 'createdChartId'
    tmpl.get('newCurves').set Curves.find(chartId: tmpl.chartId)

  'keyup .curve-title': (event, tmpl) ->
    curveId = tmpl.data._id
    curveName = tmpl.$(event.target).val()

    Curves.update {_id: curveId}, {
      $set:
        name: curveName
    }

  'click .axis-chooser': (event, tmpl) ->
    chosenAxis = getChosenAxis(event, tmpl)
    tmpl.chartSourcePicker.show chosenAxis

getChosenAxis = (event, tmpl) ->
  clickedOnChild = event.target.tagName is 'SPAN'
  if clickedOnChild
    tmpl.$(event.target).parent().data 'axis'
  else
    tmpl.$(event.target).data 'axis'