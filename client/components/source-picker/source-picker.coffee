Template.SourcePicker.onRendered ->
  analytics.track 'Opened Source Picker'

Template.SourcePicker.onCreated ->
  @showConnectorEntityPicker = new ReactiveVar false
  @entityPickerConnectorName = new ReactiveVar false

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

  @autorun =>
    data = Template.currentData()
    axisVar = data.context.axis
    if axisVar and not axisVar.get() then axisVar.set {filterBy: [], orderBy: null}


Template.SourcePicker.helpers
  showConnectorEntityPicker: -> Template.instance().showConnectorEntityPicker.get()
  connectorName: -> Template.instance().entityPickerConnectorName.get()


Template.SourcePicker.events
  'click .cancel-button': (event, tmpl) ->
    tmpl.data.instance.hide()
    tmpl.clearSearch()


  'click .save-button': (event, tmpl) ->
    tmpl.clearSearch()
    tmpl.data.instance.hide()

  'change.radiocheck [name="metricRadio"]': (event, tmpl, value) ->
    target = tmpl.$(event.target)
    metricsList = target.closest('.metrics-list')

    fieldName = tmpl.$('input:radio[name=metricRadio]:checked').val()

    axis =
      fieldName: fieldName
      connectorId: metricsList.attr('data-connector')
      entityName: metricsList.attr('data-entity')

    axisVar = tmpl.data.context.axis
    axisType = axisVar.get().type
    axisVar.set _.extend axisVar.get(), axis
    if axisType is 'x'
      Session.set 'axisVarX', axisVar.get()
    else
      Session.set 'axisVarY', axisVar.get()
