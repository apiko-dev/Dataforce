Template.SourcePicker.onCreated ->
  @showConnectorEntityPicker = new ReactiveVar false
  @entityPickerConnectorName = new ReactiveVar false

  @setEntityPickerVisibility = (visibility) => @showConnectorEntityPicker.set visibility

  @setConnectorEntity = (connectorName, entity) =>
    @setEntityPickerVisibility(false)
    Session.set connectorName, {entity: entity, enabled: true}

  @showEntityPickerFor = (connectorName) =>
    @entityPickerConnectorName.set connectorName
    @setEntityPickerVisibility true


Template.SourcePicker.helpers
  showConnectorEntityPicker: -> Template.instance().showConnectorEntityPicker.get()
  connectorName: -> Template.instance().entityPickerConnectorName.get()

