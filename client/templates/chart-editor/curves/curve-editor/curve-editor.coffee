Template.CurveEditor.onCreated ->
  @updateCurveName = =>
    updatedName = @$('.curve-name-input').val()
    if @name isnt updatedName
      Curves.update {_id: @data._id}, $set: {name: updatedName}

  @collapsedCurves = @get('collapsedCurves')
  @curveHiddenState = => @collapsedCurves.remove {curveId: @data._id}


Template.CurveEditor.helpers
  isOpened: -> !!Template.instance().collapsedCurves.findOne {curveId: @_id}

  curveType: ->
    types = Template.instance().get('curveTypes')
    _.find types, (typeObj) => @type is typeObj.type


Template.CurveEditor.events
  'keyup .curve-name-input': (event, tmpl) ->
    if event.which is 13
      tmpl.updateCurveName()

  'blur .curve-name-input': (event, tmpl) ->
    tmpl.updateCurveName()

  'click .remove-curve-button': (event, tmpl) ->
    Curves.remove _id: tmpl.data._id
    tmpl.curveHiddenState()

#    spoiler retain instance state stuff
  'show.bs.collapse .curve-wrapper': (event, tmpl) ->
    tmpl.collapsedCurves.insert {curveId: tmpl.data._id}

  'hide.bs.collapse .curve-wrapper': (event, tmpl) ->
    tmpl.curveHiddenState()

