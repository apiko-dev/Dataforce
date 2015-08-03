SETTINGS = Meteor.settings.private.GoogleAnalytics

googleapis = Meteor.npmRequire "googleapis"
googleAnalytics = googleapis.analytics "v3"
OAuth2 = googleapis.auth.OAuth2
oauth2Client = new OAuth2 SETTINGS.CLIENT_ID, SETTINGS.CLIENT_SECRET, SETTINGS.REDIRECT_URL

Meteor.methods
  "GA.generateAuthUrl": ->
    oauth2Client.generateAuthUrl
      access_type: "offline"
      scope: SETTINGS.SCOPES

  "GA.saveToken": (code) ->
    check code, String
    userId = @userId
    oauth2Client.getToken code, Meteor.bindEnvironment (err, tokens) ->
      if not err
        oauth2Client.setCredentials tokens
        gaServiceCredentials = _.extend {userId: userId}, {tokens: tokens}

        console.log gaServiceCredentials

        Connectors.update {
          userId: userId,
          name: ConnectorNames.GoogleAnalytics
        }, {$set: gaServiceCredentials}, {upsert: true}