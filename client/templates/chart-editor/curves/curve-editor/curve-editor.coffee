Template.CurveEditor.onRendered ->
  @editor = @$(".curve-wrapper")

Template.CurveEditor.helpers
  curvesList: [
    {caption: 'Line', type: 'line'}
    {caption: 'Column', type: 'line'}
    {caption: 'Area', type: 'area'}
    {caption: 'Pie', type: 'pie'}
  ]

Template.CurveEditor.events
  "click .remove-curve": (event, tmpl) ->
    tmpl.editor.slideUp 500, -> tmpl.editor.remove()

    newCurves = tmpl.get "newCurves"
    Meteor.setTimeout ->
      newCurves.set App.Functions._withoutLast newCurves.get()
    , 510
