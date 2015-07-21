rootUrl = process.env.ROOT_URL

postAuthRedirectUrl = () -> Router.routes['salesForceSample'].url()

mapAuthParams = (connection) ->
  authParamsKeys = [
    'accessToken'
    'instanceUrl'
  ]

  params = {}
  authParamsKeys.forEach (key) -> params[key] = connection[key]
  return params


redirect = (response, url) ->
  response.writeHead(302, {
    'Location': url
  })
  response.end()


createOAuth2Credentials = ->
  oAuth2 = new jsforce.OAuth2({
    clientId: Meteor.settings.private.SalesForce.key
    clientSecret: Meteor.settings.private.SalesForce.secret
    redirectUri: "#{rootUrl}oauth2/sales-force/callback"
  })

  return oAuth2


oAuth2 = createOAuth2Credentials()


Router.route 'oauth2/sales-force', ->
  redirectUrl = oAuth2.getAuthorizationUrl {}
  redirect @response, redirectUrl

, {where: 'server'}


Router.route 'oauth2/sales-force/callback', ->
  conn = new jsforce.Connection oauth2: oAuth2

  code = @params.query.code

  authorizeAsync = Meteor.wrapAsync conn.authorize, conn

  authorizeAsync code, (err, userInfo) =>
    if err
      console.error(err)
    else
      authParams = mapAuthParams conn

      sfServiceCredentials = _.extend {userId: App.temp.defaultUserId}, {salesforce: authParams}

      #save credentials
      ServiceCredentials.update {userId: App.temp.defaultUserId}, {$set: sfServiceCredentials}, {upsert: true}

      redirect @response, postAuthRedirectUrl()

, {where: 'server'}