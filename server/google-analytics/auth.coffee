SETTINGS = Meteor.settings.private.GoogleAnalytics

googleapis = Meteor.npmRequire "googleapis"
googleAnalytics = googleapis.analytics "v3"
OAuth2 = googleapis.auth.OAuth2
oauth2Client = new OAuth2 SETTINGS.CLIENT_ID, SETTINGS.CLIENT_SECRET, "#{process.env.ROOT_URL}#{SETTINGS.REDIRECT_URL}"

Meteor.methods
  "GA.generateAuthUrl": ->
    oauth2Client.generateAuthUrl
      access_type: "offline"
      scope: SETTINGS.SCOPES

  "GA.isAuthenticated": ->
    not _.isEqual oauth2Client.credentials, {}

  "GA.saveToken": (code) ->
    check code, String
    userId = @userId
    oauth2Client.getToken code, Meteor.bindEnvironment (err, tokens) ->
      if not err
        oauth2Client.setCredentials tokens
        gaServiceCredentials = _.extend {userId: userId}, {tokens: tokens}

        Connectors.update {
          userId: userId,
          name: ConnectorNames.GoogleAnalytics
        }, {$set: gaServiceCredentials}, {upsert: true}
      else handleError err

  "GA.logout": ->
    userId = @userId
    gaConnector = Connectors.findOne {userId: @userId, name: ConnectorNames.GoogleAnalytics}
    tokenToRevoke = gaConnector?.tokens?.access_token

    if tokenToRevoke
      try
        HTTP.get("https://accounts.google.com/o/oauth2/revoke?token=#{tokenToRevoke}").content

      oauth2Client.setCredentials {}

      Connectors.remove {
        userId: userId
        name: ConnectorNames.GoogleAnalytics
      }
