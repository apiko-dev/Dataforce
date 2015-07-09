CLIENT_ID = "731739422252-19e4u0b1demcma8i837cpcn2p53tiu3s.apps.googleusercontent.com"
CLIENT_SECRET = "7isvZNmXhxSFaMrUko8UADqA"
REDIRECT_URL = "http://localhost:3000/"
SCOPES = ["https://www.googleapis.com/auth/analytics.readonly"]

googleapis = Meteor.npmRequire "googleapis"
googleAnalytics = googleapis.analytics "v3"
OAuth2 = googleapis.auth.OAuth2
oauth2Client = new OAuth2

Meteor.methods
  getGAaccounts: (userId) ->
    gaCredentials = getUserCredentials userId
    oauth2Client.setCredentials gaCredentials
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
          else console.log err
          done err, result
    else {}

  getUAProfileData: (query) ->
    Async.runSync (done) ->
      googleAnalytics.data.ga.get {
        auth: oauth2Client
        'ids': 'ga:' + query.profileId
        'start-date': query.from
        'end-date': query.to
        'metrics': 'ga:visits'
      }, (err, result) ->
        err and console.log err
        done err, result


getUserCredentials = (userId) ->
  userObj = Meteor.users.findOne _id: userId
  credentials =
    access_token: userObj?.services?.google?.accessToken
    token_type: "Bearer"
    refresh_token: userObj?.services?.google?.refreshToken
  credentials

