Template.CurveEditor.helpers
  curvesList: [
    {caption: 'Line', type: 'line'}
    {caption: 'Column', type: 'line'}
    {caption: 'Area', type: 'area'}
    {caption: 'Pie', type: 'pie'}
  ]

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