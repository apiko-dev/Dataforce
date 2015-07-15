createOAuth2Credentials = ->
  credentials = JSON.parse Assets.getText 'sf-api.json'

  oAuth2 = new jsforce.OAuth2({
    clientId: credentials.key
    clientSecret: credentials.secret
    redirectUri: 'http://localhost:3000/oauth2/sales-force/callback'
  })

  return oAuth2


mapAuthParams = (connection) ->
  authParamsKeys = [
    'accessToken'
    'refreshToken'
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


oAuth2 = createOAuth2Credentials()


Router.route 'oauth2/sales-force', ->
  redirectUrl = oAuth2.getAuthorizationUrl {}
  redirect @response, redirectUrl

, {where: 'server'}


Router.route 'oauth2/sales-force/callback', ->
  conn = new jsforce.Connection oauth2: oAuth2

  code = @params.query.code

  conn.authorize code, (err, userInfo) =>
    if err
      console.error(err)
    else
      authParams = mapAuthParams conn
      redirect @response, Router.routes['salesForceSample'].url(authParams)

, {where: 'server'}