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
}