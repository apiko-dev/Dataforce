Template.CurveTypeChooser.onRendered ->
  @$('.curve-type-chooser .btn').eq(0).addClass 'pressed'


Template.CurveTypeChooser.helpers
  curveTypes: -> [
    {
      caption: 'Line'
      type: 'line'
      icon: 'fa-line-chart'
    }
    {
      caption: 'Column'
      type: 'column'
      icon: 'fa-bar-chart'
    }
    {
      caption: 'Area'
      type: 'area'
      icon: 'fa-area-chart'
    }
    {
      caption: 'Pie'
      type: 'pie'
      icon: 'fa-pie-chart'
    }
  ]


Template.CurveTypeChooser.events
  'click .curve-type-chooser .btn': (event, tmpl) ->
    buttonObject = tmpl.$(event.target)
    otherButtons = tmpl.$('.curve-type-chooser .btn')

    chosenCurveType = buttonObject.data 'type'

    otherButtons.removeClass "pressed"
    buttonObject.addClass "pressed"
