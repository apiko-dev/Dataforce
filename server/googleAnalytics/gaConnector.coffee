CLIENT_ID = "492445934834-1pbljtblmkddmjqv978a81a0vb3j59r6.apps.googleusercontent.com"
CLIENT_SECRET = "NpuwJp2HB7454YiGET16F5c9"
REDIRECT_URL = "http://localhost:3000/google-analytics-sample"
SCOPES = ['openid', 'email', 'profile', 'https://www.googleapis.com/auth/analytics.readonly']

googleapis = Meteor.npmRequire "googleapis"
googleAnalytics = googleapis.analytics "v3"
OAuth2 = googleapis.auth.OAuth2
oauth2Client = new OAuth2 CLIENT_ID, CLIENT_SECRET, REDIRECT_URL

Meteor.methods
  getGAAuthUrl: ->
    oauth2Client.generateAuthUrl
      access_type: "offline"
      scope: SCOPES

  saveGAToken: (code) ->
    oauth2Client.getToken code, (err, tokens) ->
      console.log err, tokens
      if not err
        oauth2Client.setCredentials tokens

  getGAaccounts: (userId) ->
    profilesListJson = Async.runSync (done) ->
      googleAnalytics.management.profiles.list {
        auth: oauth2Client
        accountId: "~all"
        webPropertyId: "~all"
      }, (err, result) ->
        done err, result

    if profilesListJson.error is null
      Async.runSync (done) ->
        Meteor.call "getProfilesList", profilesListJson, (err, result) ->
          if not err
            console.log "Found #{result.length} profiles"
          else console.error err
          done err, result
    else
      console.log profilesListJson.error
      {}

  getUAProfileData: (query) ->
    Async.runSync (done) ->
      googleAnalytics.data.ga.get {
        auth: oauth2Client
        "ids": "ga:" + query.profileId
        "start-date": query.from
        "end-date": query.to
        "metrics": query.metrics
        "dimensions": query.dimensions
      }, (err, result) ->
        err and console.log err
        console.log result
        done err, result?.rows
