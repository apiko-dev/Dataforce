Template.CurveEditorTabs.onCreated ->
  @currentTab = new ReactiveVar(false)

  @setCurrentTabByConnector = (connector) =>
    @currentTab.set _.find tabs, (tab) -> tab.connector is connector

  @autorun =>
    connector = Template.currentData().source
    @setCurrentTabByConnector(connector)


Template.CurveEditorTabs.helpers
  currentTab: -> Template.instance().currentTab.get()
  editorTabs: -> tabs

  isActive: ->
    current = Template.instance().currentTab.get()
    @connector is current.connector


Template.CurveEditorTabs.events
  'click .tab': (event, tmpl) ->
    connector = tmpl.$(event.target).closest('.tab').data('connector')
    Curves.update {_id: tmpl.data._id}, $set: {source: connector, metadata: {}}


tabs = [
# GA temporally unavailable
#  {
#    connector: ConnectorNames.GoogleAnalytics,
#    iconUrl: '/connectors/ga-small-logo.png',
#    template: 'GoogleAnalyticsCurveEditorTab'
#  }
  {
    connector: ConnectorNames.Salesforce,
    iconUrl: '/connectors/sf-small-logo.png',
    template: 'SalesforceCurveEditorTab'
  }
  {
    connector: ConnectorNames.Dataforce,
    iconUrl: '/connectors/df-small-logo.png',
    template: 'DataforceCurveEditorTab'
  }
]
