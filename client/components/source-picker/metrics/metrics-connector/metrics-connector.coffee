Template.MetricsConnector.onCreated ->
  @metrics = new ReactiveVar(false)
  @autorun =>
    connectorConfig = Session.get @data.name
    if connectorConfig and connectorConfig.entity and connectorConfig.enabled
      Meteor.call @data.method, connectorConfig.entity, App.handleError (metrics) =>
        @metrics.set metrics


Template.MetricsConnector.helpers
  config: -> Session.get @name
  metrics: -> Template.instance().metrics.get()