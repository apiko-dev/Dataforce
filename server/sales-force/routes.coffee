rootUrl = process.env.ROOT_URL

postAuthRedirectUrl = () -> Router.routes['salesForceSample'].url()


mapAuthParams = (connection) ->
  authParamsKeys = [
    'accessToken'
    'instanceUrl'
    'refreshToken'
  ]

  params = {}
  authParamsKeys.forEach (key) -> params[key] = connection[key]
  return params


redirect = (response, url) ->
  response.writeHead(302, {
    'Location': url
  })
  response.end()


createOAuth2Credentials = (userId) ->
  oAuth2 = new jsforce.OAuth2({
    clientId: Meteor.settings.private.SalesForce.key
    clientSecret: Meteor.settings.private.SalesForce.secret
    redirectUri: "#{rootUrl}oauth2/sales-force/callback?userid=#{userId}"
  })

  return oAuth2


Router.route 'oauth2/sales-force/login/:userId', ->
  userId = @params['userId']

  redirectUrl = createOAuth2Credentials(userId).getAuthorizationUrl {
    scope: 'full refresh_token'
  }

  redirect @response, redirectUrl

, {where: 'server'}


Router.route 'oauth2/sales-force/callback', ->
#todo find way to remove hardcoded value
#  todo get user id from search of uri
  userId = 'LiduvK4MQaFkJqMAn'

  console.log 'callback query: ', @params.query

  conn = new jsforce.Connection oauth2: createOAuth2Credentials(userId)

  code = @params.query.code

  authorizeAsync = Meteor.wrapAsync conn.authorize, conn

  authorizeAsync code, (err, userInfo) =>
    if err
      console.error(err)
    else
      authParams = mapAuthParams conn

      sfServiceCredentials = _.extend {userId: userId}, {salesforce: authParams}

      #save credentials
      ServiceCredentials.update {userId: userId}, {$set: sfServiceCredentials}, {upsert: true}

      redirect @response, postAuthRedirectUrl()

, {where: 'server'}