class ZendeskDataAdapter
  constructor: (@chartQuery) ->

  getSeries: (onDataReady) ->
    self = @
    Meteor.call "Zendesk.getJsonData", @chartQuery, (err, result) ->
      data = new App.DataTransformers.Zendesk self.chartQuery.query, result
      onDataReady data.getSeries()

_.extend App.DataAdapters, {
  Zendesk: ZendeskDataAdapter
}