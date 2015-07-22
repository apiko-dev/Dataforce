CLIENT_ID = "492445934834-1pbljtblmkddmjqv978a81a0vb3j59r6.apps.googleusercontent.com"
CLIENT_SECRET = "NpuwJp2HB7454YiGET16F5c9"
REDIRECT_URL = "http://localhost:3000/google-analytics-sample"
SCOPES = ['openid', 'email', 'profile', 'https://www.googleapis.com/auth/analytics.readonly']

googleapis = Meteor.npmRequire "googleapis"
googleAnalytics = googleapis.analytics "v3"
OAuth2 = googleapis.auth.OAuth2
oauth2Client = new OAuth2 CLIENT_ID, CLIENT_SECRET, REDIRECT_URL

Meteor.methods
  "GA.loadTokens": ->
    tokens = ServiceCredentials.findOne {userId: App.temp.defaultUserId}, fields: {googleAnalytics: 1}
    oauth2Client.setCredentials tokens.googleAnalytics

  "GA.generateAuthUrl": ->
    oauth2Client.generateAuthUrl
      access_type: "offline"
      scope: SCOPES

  "GA.saveToken": (code) ->
    check code, String
    oauth2Client.getToken code, Meteor.bindEnvironment((err, tokens) ->
      if not err
        oauth2Client.setCredentials tokens
        gaServiceCredentials = _.extend {userId: App.temp.defaultUserId}, {googleAnalytics: tokens}
        ServiceCredentials.update {userId: App.temp.defaultUserId}, {$set: gaServiceCredentials}, {upsert: true}
    )

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
        console.log el.accountId
        accountId: el.accountId
        profileId: el.id
        webPropertyId: el.webPropertyId
        name: if el.websiteUrl.length > 3 then el.websiteUrl else el.webPropertyId
    else
      console.log profilesListJson.error
      []

  "GA.getData": (query) ->
    check query,
      profileId: String
      metrics: String
      mergeMetrics: Boolean
      dimensions: String
      from: String
      to: String

    Async.runSync (done) ->
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
