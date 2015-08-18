Template.CurveEditor.onCreated ->
  @updateCurveName = =>
    updatedName = @$('.curve-name-input').val()
    if @name isnt updatedName
      Curves.update {_id: @data._id}, $set: {name: updatedName}


Template.CurveEditor.helpers
  isOpened: -> !!Template.instance().get('collapsedCurves').findOne {curveId: @_id}


Template.CurveEditor.events
  'keyup .curve-name-input': (event, tmpl) ->
    if event.which is 13
      tmpl.updateCurveName()

  'blur .curve-name-input': (event, tmpl) ->
    tmpl.updateCurveName()

  'click .remove-curve-button': (event, tmpl) ->
    Curves.remove _id: tmpl.data._id

#    spoiler retain instance state stuff
  'show.bs.collapse .curve-wrapper': (event, tmpl) ->
    tmpl.get('collapsedCurves').insert {curveId: tmpl.data._id}

  'hide.bs.collapse .curve-wrapper': (event, tmpl) ->
    tmpl.get('collapsedCurves').remove {curveId: tmpl.data._id}


