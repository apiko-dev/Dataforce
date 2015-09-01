Template.DataforceCurveEditorTab.onCreated ->
  @activePickerId = new ReactiveVar(false)

Template.DataforceCurveEditorTab.helpers
  referenceSupportCurves: -> Curves.find {'metadata.dimension.type': 'date'}, {fields: {_id: 1, name: 1}}

  availableDeltas: -> [
#    {name: 'decade', label: 'Decade'}
#    {name: 'quarter', label: 'Quarter'}
    {name: 'year', label: 'Year'}
    {name: 'month', label: 'Month'}
    {name: 'day', label: 'Day'}
  ]