Template.SfMetadataPicker.onCreated ->
  @activePickerId = @get('activePickerId')
  @searchPhrase = new ReactiveVar('')

  @isRootPropertyName = => @data.propertyName is ''
  @getDocumentProperty = =>
    metadata = @data.doc.metadata
    if @isRootPropertyName() then metadata else metadata?[@data.propertyName]

  @getUpdateQuery = (value) =>
    updateQuery = {}
    documentPropertyPath = "metadata"
    documentPropertyPath += ".#{@data.propertyName}" unless @isRootPropertyName()
    updateQuery[documentPropertyPath] = value
    return updateQuery

  @closePicker = =>
    @searchPhrase.set ''
    @activePickerId.set false


Template.SfMetadataPicker.helpers
  isExpanded: -> Template.instance().activePickerId.get() is @id

  value: -> Template.instance().getDocumentProperty()?.label

  isMatchSearchQuery: ->
    searchPhrase = Template.instance().searchPhrase.get().toLowerCase()
    @label.toLowerCase().indexOf(searchPhrase) >= 0


Template.SfMetadataPicker.events
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
    value = _.find tmpl.data.items, (item) -> item.name is radioValue

    delete value._id

    Curves.update {_id: documentId}, $set: tmpl.getUpdateQuery(value)
