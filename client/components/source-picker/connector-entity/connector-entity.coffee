Template.ConnectorEntity.onCreated ->
  @sourcePickerTemplate = @findParentTemplate('SourcePicker')

  @sfEntries = new ReactiveVar(false)
  Meteor.call 'sfGetConnectorEntries', App.handleError (entries) => @sfEntries.set entries


Template.ConnectorEntity.helpers
  entities: ->
    tmpl = Template.instance()

    if @connectorName is ConnectorNames.Salesforce
      tmpl.sfEntries.get()
    else if @connectorName is ConnectorNames.GoogleAnalytics
#    todo: add google analytics accounts list support
      []
    else []


Template.ConnectorEntity.events
  'click .cancel-button': (event, tmpl) ->
    tmpl.sourcePickerTemplate.setEntityPickerVisibility(false)

  'click .entity-item': (event, tmpl) ->
    entity = $(event.target).attr('data-entity')
    tmpl.sourcePickerTemplate.setConnectorEntity tmpl.data.connectorName, entity
