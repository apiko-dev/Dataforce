App.SalesForce.Connector = {
  createOAuth2Credentials: () ->
    oAuth2 = new jsforce.OAuth2({
      clientId: Meteor.settings.private.SalesForce.key
      clientSecret: Meteor.settings.private.SalesForce.secret
      redirectUri: "#{process.env.ROOT_URL}oauth2/sales-force/callback"
    })
    return oAuth2


  createConnection: (credentials) ->
    return new jsforce.Connection
      oauth2: {
        clientId: Meteor.settings.private.SalesForce.key
        clientSecret: Meteor.settings.private.SalesForce.secret
      }
      accessToken: credentials.accessToken
      instanceUrl: credentials.instanceUrl


  getConnectorByUserId: (userId) -> Connectors.findOne {userId: userId, name: ConnectorNames.Salesforce}


  updateApiUsage: (userId, apiUsage) ->
    Connectors.update {userId: userId, name: ConnectorNames.Salesforce},
      $set: {apiUsage: apiUsage}


  refreshToken: (userId) ->
    connector = @getConnectorByUserId userId
    oAuth2 = @createOAuth2Credentials()
    syncRes = Async.runSync (done) -> oAuth2.refreshToken connector.tokens.refreshToken, done

    if syncRes.error
      throw syncRes.error
    else
      accessToken = syncRes.result.access_token
      Connectors.update {userId: userId, name: ConnectorNames.Salesforce}, {$set: {'tokens.accessToken': accessToken}}


  revokeToken: (userId) ->
    connector = @getConnectorByUserId userId
    oAuth2 = @createOAuth2Credentials()
    oAuth2.revokeToken connector.tokens.accessToken, Meteor.bindEnvironment (err, res) ->
      if err
        console.log err
      else
        Connectors.remove {_id: connector._id}

}