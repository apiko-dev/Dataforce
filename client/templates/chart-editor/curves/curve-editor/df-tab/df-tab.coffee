Template.DataforceCurveEditorTab.onCreated ->
  @activePickerId = new ReactiveVar(false)

Template.DataforceCurveEditorTab.helpers
  referenceSupportCurves: -> Curves.find {'metadata.dimension.type': 'date'}, {fields: {_id: 1, name: 1}}