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


Template.SourcePicker.events
  'click .cancel-button': (event, tmpl) ->
    tmpl.data.instance.hide()


  'click .save-button': (event, tmpl) ->
    metric = tmpl.$('[name="metricRadio"]').val()
    console.log 'metric:', tmpl.$('[name="metricRadio"]').val()

  'change.radiocheck [name="metricRadio"]': (event, tmpl, value) ->
    console.log 'change', event, value
