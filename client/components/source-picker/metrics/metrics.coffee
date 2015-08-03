Template.Metrics.onCreated ->
  @sfMetrics = new ReactiveVar(false)
  @autorun =>
    connectorConfig = Session.get ConnectorNames.Salesforce
    if connectorConfig and connectorConfig.entity
      Meteor.call 'sfDescribe', connectorConfig.entity, App.handleError (metrics) =>
        @sfMetrics.set metrics


Template.Metrics.helpers
  metrics: -> Template.instance().sfMetrics.get()
