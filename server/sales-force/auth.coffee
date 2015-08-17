SF_AUTH_URL = Meteor.settings.public.SalesForce.authUrl

redirect = (response, url) ->
  response.writeHead(302, {
    'Location': url
  })
  response.end()


Router.route SF_AUTH_URL,
  where: 'server'
  action: ->
    redirectUrl = App.SalesForce.Connector.createOAuth2Credentials().getAuthorizationUrl {
      scope: 'full refresh_token'
    }
    redirect @response, redirectUrl


Meteor.methods
  onSalesForceLogin: (authCode) ->
    check authCode, String

    userId = Meteor.userId()

    conn = new jsforce.Connection
      oauth2: App.SalesForce.Connector.createOAuth2Credentials()

    authorizeAsync = Meteor.wrapAsync conn.authorize, conn

    authorizeAsync authCode, (err, userInfo) =>
      if err
        console.error(err)
      else
        mapAuthParams = (connection) ->
          params = {}
          [
            'accessToken'
            'instanceUrl'
            'refreshToken'
          ].forEach (key) -> params[key] = connection[key]
          return params

        authParams = mapAuthParams conn

        sfServiceCredentials = _.extend {userId: userId}, {tokens: authParams}

        #save credentials
        Connectors.update {
          userId: userId,
          name: ConnectorNames.Salesforce
        }, {$set: sfServiceCredentials}, {upsert: true}


  sfRevokeAccess: () ->
    App.SalesForce.Connector.revokeToken @userId