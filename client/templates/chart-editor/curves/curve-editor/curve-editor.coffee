Template.CurveEditor.onCreated ->
  @updateCurveName = =>
    updatedName = @$('.curve-name-input').val()
    if @name isnt updatedName
      Curves.update {_id: @data._id}, $set: {name: updatedName}


Template.CurveEditor.helpers
  isNew: -> Template.instance().get('newCurveId').get() is @_id


Template.CurveEditor.events
  'keyup .curve-name-input': (event, tmpl) ->
    if event.which is 13
      tmpl.updateCurveName()

  'blur .curve-name-input': (event, tmpl) ->
    tmpl.updateCurveName()

  'click .remove-curve-button': (event, tmpl) ->
    Curves.remove _id: tmpl.data._id
