Template.CurveTypeChooser.onRendered ->
  @$('.curve-type-chooser .btn').eq(0).addClass 'pressed'

Template.CurveTypeChooser.events
  'click .curve-type-chooser .btn': (event, tmpl) ->
    buttonObject = tmpl.$(event.target)
    otherButtons = tmpl.$('.curve-type-chooser .btn')

    chosenCurveType = buttonObject.data 'type'

    otherButtons.removeClass "pressed"
    buttonObject.addClass "pressed"
