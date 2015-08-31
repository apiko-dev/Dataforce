Template.DfMetadataPicker.onCreated ->
  @activePickerId = @get('activePickerId')
  @searchPhrase = new ReactiveVar('')

  @getUpdateQuery = (value) =>
    updateQuery = {}
    updateQuery["metadata.#{@data.propertyName}"] = value
    return updateQuery

  @closePicker = =>
    @searchPhrase.set ''
    @activePickerId.set false


Template.DfMetadataPicker.helpers
  isExpanded: -> Template.instance().activePickerId.get() is @id

  value: ->
    curveId = @doc.metadata?[@propertyName]
    if curveId then Curves.findOne({_id: curveId}).name

  isMatchSearchQuery: ->
    searchPhrase = Template.instance().searchPhrase.get().toLowerCase()
    @name.toLowerCase().indexOf(searchPhrase) >= 0


Template.DfMetadataPicker.events
  'click .metadata-picker': (event, tmpl) ->
    if tmpl.activePickerId.get() isnt @id then tmpl.activePickerId.set tmpl.data.id


  'keyup .search-input': (event, tmpl) ->
    applyNewSearchPhrase = ->
      current = tmpl.searchPhrase.get()
      next = tmpl.$('.search-input').val()
      if current isnt next
        tmpl.searchPhrase.set next

    #timeout prevents lags while typing text in search field
    #clear old timeout
    if tmpl._searchQueryTimeout then Meteor.clearTimeout tmpl._searchQueryTimeout
    #setup new one
    tmpl._searchQueryTimeout = Meteor.setTimeout applyNewSearchPhrase, 300


  'click .cancel-button': (event, tmpl) ->
    event.stopPropagation()
    tmpl.closePicker()


  'click .select-value-button': (event, tmpl) ->
    event.stopPropagation()
    tmpl.closePicker()

    documentId = tmpl.data.doc._id

    radioValue = tmpl.$("input:radio[name=pickerValue_#{documentId}]:checked").val()

    Curves.update {_id: documentId}, $set: tmpl.getUpdateQuery(radioValue) if radioValue
