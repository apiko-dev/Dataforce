App.Connectors.Salesforce = {
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


  refreshToken: (userId) ->
    connector = @getConnectorByUserId userId
    oAuth2 = @createOAuth2Credentials()
    syncRes = Async.runSync (done) -> oAuth2.refreshToken connector.tokens.refreshToken, done

    if syncRes.error
#todo remove this message after successful token refresh
      console.log 'ERROR WHILE REFRESHING TOKEN.'
      throw syncRes.error
    else
      Connectors.update {userId: userId, name: ConnectorNames.Salesforce}, {$set: {tokens: syncRes.result}}
      console.log 'SALESFORCE REFRESH_TOKEN UPDATED'
      console.log @getConnectorByUserId(userId)


  revokeToken: (userId) ->
#    todo: check this method
    connector = @getConnectorByUserId userId
    oAuth2 = @createOAuth2Credentials()
    oAuth2.revokeToken connector.tokens.accessToken, Meteor.bindEnvironment () ->
      Connectors.remove {_id: connector._id}

}