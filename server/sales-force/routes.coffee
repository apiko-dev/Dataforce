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
    redirectUri: 'http://localhost:3000/oauth2/sales-force/callback'
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

  conn.authorize code, (err, userInfo) =>
    if err
      console.error(err)
    else
      authParams = mapAuthParams conn
      authParams.userId = userInfo.id
      url = Router.routes['salesForceSample'].url()
      query = '?' + Object.keys(authParams).map((key)-> key + '=' + authParams[key]).join('&')
      redirect @response, url + query

, {where: 'server'}