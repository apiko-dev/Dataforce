Template.CurveEditor.onRendered ->
  @editor = @$('.curve-wrapper')

Template.CurveEditor.helpers
  curvesList: [
    {caption: 'Line', type: 'line'}
    {caption: 'Column', type: 'line'}
    {caption: 'Area', type: 'area'}
    {caption: 'Pie', type: 'pie'}
  ]

Template.CurveEditor.events
  'click .remove-curve': (event, tmpl) ->
    tmpl.editor.slideUp 500, -> tmpl.editor.remove()

    newCurves = tmpl.get "newCurves"
    Meteor.setTimeout ->
      # todo: rewrite considering removing the specific curve, not last
      newCurves.set _.reject newCurves.get(), (num, i) -> (newCurves.get().length - 1) is i
    , 510

  'keyup .curve-title': (event, tmpl) ->
    curveId = tmpl.get 'newCurveId'
    curveName = tmpl.$(event.target).val()

    Curves.update {_id: curveId}, {
      $set:
        name: curveName
    }