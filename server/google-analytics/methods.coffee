SETTINGS = Meteor.settings.private.GoogleAnalytics

googleapis = Meteor.npmRequire "googleapis"
googleAnalytics = googleapis.analytics "v3"
OAuth2 = googleapis.auth.OAuth2
oauth2Client = new OAuth2 SETTINGS.CLIENT_ID, SETTINGS.CLIENT_SECRET, SETTINGS.REDIRECT_URL

Meteor.methods
  "GA.getDimensionsList": -> JSON.parse Assets.getText "ga/ga-dimensions-list.json"

  "GA.getMetricsList": -> JSON.parse Assets.getText "ga/ga-metrics-list.json"

  "GA.loadTokens": ->
    gaConnector = Connectors.findOne {userId: @userId, name: ConnectorNames.GoogleAnalytics}
    if gaConnector
      oauth2Client.setCredentials gaConnector.tokens

  "GA.getAccounts": ->
    profilesListJson = Async.runSync (done) ->
      googleAnalytics.management.profiles.list {
        auth: oauth2Client
        accountId: "~all"
        webPropertyId: "~all"
      }, (err, result) ->
        done err, result

    if profilesListJson.error is null
      _.map profilesListJson.result.items, (el) ->
        accountId: el.accountId
        profileId: el.id
        webPropertyId: el.webPropertyId
        name: if el.websiteUrl.length > 3 then el.websiteUrl else el.webPropertyId
    else
      console.log profilesListJson.error
      []

  "GA.getSeries": (query) ->
    check query,
      profileId: String
      metrics: String
      mergeMetrics: Boolean
      dimensions: String
      from: String
      to: String

    rawJson = Async.runSync (done) ->
      googleAnalytics.data.ga.get {
        auth: oauth2Client
        ids: "ga:" + query.profileId
        "start-date": query.from
        "end-date": query.to
        metrics: query.metrics
        dimensions: query.dimensions
      }, (err, result) ->
        err and console.log err
        done err, result

    dataAdapter = new App.DataAdapters.GoogleAnalytics query, rawJson
    dataAdapter.getSeries()
