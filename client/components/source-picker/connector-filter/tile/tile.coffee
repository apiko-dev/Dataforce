Template.ConnectorFilterTile.onRendered ->
  @sourcePickerTemplate = @findParentTemplate('SourcePicker')

  @showEntityPicker = =>
    @sourcePickerTemplate.showEntityPickerFor(@data.name)

  enbleSwitch = @$('.enable-connector')
  enbleSwitch.bootstrapSwitch()
  @getConfig = => Session.get @data.name
  @autorun =>
    connectorConfig = @getConfig()
    enbleSwitch.bootstrapSwitch('state', !!(connectorConfig and connectorConfig.enabled))


Template.ConnectorFilterTile.helpers
  currentEntity: -> Session.get(@name)?.entity


Template.ConnectorFilterTile.events
  'click .configure-source': (event, tmpl) -> tmpl.showEntityPicker()

  'switchChange.bootstrapSwitch .enable-connector': (event, tmpl, state) ->
    config = tmpl.getConfig()
    if config and config.entity
      config.enabled = state
      Session.set tmpl.data.name, config
    else
      tmpl.showEntityPicker()


Template.ConnectorFilterTile.onDestroyed ->
  @$('.enable-connector').bootstrapSwitch('destroy')

