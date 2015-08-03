Template.ConnectorEntity.onCreated ->
  @sourcePickerTemplate = @findParentTemplate('SourcePicker')
  @getCurrentConnector = => Session.get('currentConnector')

  @sfEntries = new ReactiveVar(false)
  Meteor.call 'sfGetConnectorEntries', App.handleError (entries) => @sfEntries.set entries


Template.ConnectorEntity.helpers
  connector: -> Template.instance().getCurrentConnector()
  entities: ->
    tmpl = Template.instance()
    #    todo: add google analytics support
    if tmpl.getCurrentConnector()?._id is 'SF' then tmpl.sfEntries.get() else []


Template.ConnectorEntity.events
  'click .cancel-button': (event, tmpl) ->
    tmpl.sourcePickerTemplate.setEntityPickerVisibility(false)

  'click .entity-item': (event, tmpl) ->
    entity = $(event.target).attr('data-entity')
    console.log 'entity: ', entity
    tmpl.sourcePickerTemplate.setConnectorEntity tmpl.getCurrentConnector(), entity