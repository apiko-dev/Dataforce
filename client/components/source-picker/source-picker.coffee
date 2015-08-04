Template.SourcePicker.onCreated ->
  @showConnectorEntityPicker = new ReactiveVar false
  @entityPickerConnectorName = new ReactiveVar false
  @modalResult = new ReactiveVar {filterBy: [], orderBy: null}

  @setEntityPickerVisibility = (visibility) => @showConnectorEntityPicker.set visibility

  @setConnectorEntity = (connectorName, entity) =>
    @setEntityPickerVisibility(false)
    Session.set connectorName, {entity: entity, enabled: true}

  @showEntityPickerFor = (connectorName) =>
    Session.set('searchQuery', '')
    @entityPickerConnectorName.set connectorName
    @setEntityPickerVisibility true

  @clearSearch = -> Session.set('searchQuery', '')
  @clearSearch()


Template.SourcePicker.helpers
  showConnectorEntityPicker: -> Template.instance().showConnectorEntityPicker.get()
  connectorName: -> Template.instance().entityPickerConnectorName.get()


Template.SourcePicker.events
  'click .cancel-button': (event, tmpl) ->
    tmpl.data.instance.hide()
    tmpl.clearSearch()

  'click .save-button': (event, tmpl) ->
    clearSearch()
    metric = tmpl.$('[name="metricRadio"]').val()
    console.log 'metric:', tmpl.$('[name="metricRadio"]').val()

  'change.radiocheck [name="metricRadio"]': (event, tmpl, value) ->
    target = tmpl.$(event.target)
    metricsList = target.closest('.metrics-list')
    console.log target, metricsList

    axis =
      fieldName: tmpl.$('[name="metricRadio"]').val()
      connectorId: metricsList.attr('data-connector')
      entityName: metricsList.attr('data-entity')

    prevAxis = tmpl.modalResult.get()
    tmpl.modalResult.set _.extend prevAxis, axis