Template.SourcePicker.onCreated ->
  @showConnectorEntityPicker = new ReactiveVar(false)

  @setEntityPickerVisibility = (visibility) => @showConnectorEntityPicker.set visibility
  @setConnectorEntity = (connector, entity) =>
    @setEntityPickerVisibility(false)
    console.log 'connector config', connector, entity

  @showEntityPickerFor = (connector) =>
    Session.set('currentConnector', connector)
    @setEntityPickerVisibility(true)


Template.SourcePicker.helpers
  showConnectorEntityPicker: -> Template.instance().showConnectorEntityPicker.get()

