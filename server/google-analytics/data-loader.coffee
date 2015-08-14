SETTINGS = Meteor.settings.private.GoogleAnalytics

googleapis = Meteor.npmRequire "googleapis"
googleAnalytics = googleapis.analytics "v3"
OAuth2 = googleapis.auth.OAuth2
oauth2Client = new OAuth2 SETTINGS.CLIENT_ID, SETTINGS.CLIENT_SECRET, "#{process.env.ROOT_URL}#{SETTINGS.REDIRECT_URL}"

class GoogleAnalyticsDataLoader
  constructor: (@metadata, @userId) ->

  getJSON: ->
    loadTokens @userId
    rawJson = Async.runSync (done) ->
      googleAnalytics.data.ga.get {
        auth: oauth2Client
        ids: "ga:" + @metadata.profileId
        "start-date": @metadata.from
        "end-date": @metadata.to
        metrics: @metadata.metric
        dimensions: @metadata.dimension
      }, (err, result) ->
        done err, result


###
  todo
  temporary solution. will be refactored after the basic example will be working
  just copy-pasted this function in order to make the example work more quickly
  as soon as everything will be working, i'll return here and write things the right way
  i promise
###
loadTokens = (userId) ->
  gaConnector = Connectors.findOne {userId: userId, name: ConnectorNames.GoogleAnalytics}
  if gaConnector
    oauth2Client.setCredentials gaConnector.tokens