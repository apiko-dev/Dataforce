Template.SfMetadataPicker.onCreated ->
  @activePickerId = @get('activePickerId')


Template.SfMetadataPicker.helpers
  isExpanded: -> Template.instance().activePickerId.get() is @id
  value: -> @doc.metadata[@propertyName]


Template.SfMetadataPicker.events
  'click .metadata-picker': (event, tmpl) ->
    if tmpl.activePickerId.get() isnt @id then tmpl.activePickerId.set tmpl.data.id

  'click .select-value-button': (event, tmpl) ->
    event.stopPropagation()
    tmpl.activePickerId.set false

    #    todo get value here
    value = 'test'

    updateQuery = {}
    updateQuery["metadata.#{tmpl.data.propertyName}"] = value
    Curves.update {_id: tmpl.data.doc._id}, $set: updateQuery
