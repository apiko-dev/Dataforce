Template.CurveTypeChooser.onRendered ->
  @pressButtonByChartType = (type) =>
    @$('.curve-type-chooser .btn').removeClass 'pressed'
    @$(".curve-type-chooser .btn[data-type=\"#{type}\"]").addClass 'pressed'

  #initialize curve type
  @pressButtonByChartType(@data.type)


Template.CurveTypeChooser.helpers
  curveTypes: -> Template.instance().get('curveTypes')


Template.CurveTypeChooser.events
  'click .curve-type-chooser .btn': (event, tmpl) ->
#    get type by pressed button
    type = tmpl.$(event.target).data 'type'

    tmpl.pressButtonByChartType(type)

    Curves.update {_id: tmpl.data._id}, $set: {type: type}