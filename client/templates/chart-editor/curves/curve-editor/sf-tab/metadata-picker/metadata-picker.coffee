Template.SfMetadataPicker.onCreated ->
  @activePickerId = @get('activePickerId')
  @searchPhrase = new ReactiveVar('')


Template.SfMetadataPicker.helpers
  isExpanded: -> Template.instance().activePickerId.get() is @id

  value: -> @doc.metadata?[@propertyName]?.label

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


  'click .select-value-button': (event, tmpl) ->
    event.stopPropagation()
    tmpl.activePickerId.set false

    radioValue = tmpl.$('input:radio[name=pickerValue]:checked').val()
    value = _.find tmpl.data.items, (item) -> item.name is radioValue

    updateQuery = {}
    updateQuery["metadata.#{tmpl.data.propertyName}"] = value
    Curves.update {_id: tmpl.data.doc._id}, $set: updateQuery
