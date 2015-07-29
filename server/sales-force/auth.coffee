SF_AUTH_URL = Meteor.settings.public.SalesForce.authUrl

redirect = (response, url) ->
  response.writeHead(302, {
    'Location': url
  })
  response.end()


Router.route SF_AUTH_URL, ->
  redirectUrl = App.Connectors.Salesforce.createOAuth2Credentials().getAuthorizationUrl {
    scope: 'full refresh_token'
  }

  redirect @response, redirectUrl

, {where: 'server'}


Meteor.methods
  onSalesForceLogin: (authCode) ->
    check authCode, String

    userId = Meteor.userId()

    conn = new jsforce.Connection
      oauth2: App.Connectors.Salesforce.createOAuth2Credentials()

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

        sfServiceCredentials = _.extend {userId: userId}, {salesforce: authParams}

        #save credentials
        ServiceCredentials.update {userId: userId}, {$set: sfServiceCredentials}, {upsert: true}
