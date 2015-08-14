tabs = [
  {
    connector: ConnectorNames.GoogleAnalytics,
    iconUrl: '/connectors/ga-small-logo.png',
    template: 'GoogleAnalyticsCurveEditorTab'
  }
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

Template.CurveEditorTabs.onCreated ->
  @currentTab = new ReactiveVar tabs[0]


Template.CurveEditorTabs.onRendered ->
  curveId = tmpl.data._id
  Curves.update {_id: curveId}, {
    $set:
      source: tabs[0].connector
  }

Template.CurveEditorTabs.helpers
  currentTab: -> Template.instance().currentTab.get()
  editorTabs: -> tabs
  isActive: ->
    current = Template.instance().currentTab.get()
    @connector is current.connector


Template.CurveEditorTabs.events
  'click .tab': (event, tmpl) ->
    connector = tmpl.$(event.target).closest('.tab').data('connector')
    tmpl.currentTab.set _.find tabs, (tab) -> tab.connector is connector

    curveId = tmpl.data._id
    Curves.update {_id: curveId}, {
      $set:
        source: connector
    }