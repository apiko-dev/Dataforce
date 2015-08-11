Template.ConnectorEntity.onCreated ->
  @sourcePickerTemplate = @findParentTemplate('SourcePicker')

  @resetSearch = -> Session.set('searchQuery', '')


Template.ConnectorEntity.helpers
  entities: ->
    if @connectorName is ConnectorNames.Salesforce
      ReactiveMethod.call 'sfGetConnectorEntries'
    else if @connectorName is ConnectorNames.GoogleAnalytics
      ReactiveMethod.call 'GA.getAccounts'
    else []


Template.ConnectorEntity.events
  'click .cancel-button': (event, tmpl) ->
    tmpl.sourcePickerTemplate.setEntityPickerVisibility(false)
    tmpl.resetSearch()

  'click .entity-item': (event, tmpl) ->
    entity = $(event.target).attr('data-entity')
    tmpl.sourcePickerTemplate.setConnectorEntity tmpl.data.connectorName, entity
    tmpl.resetSearch()
