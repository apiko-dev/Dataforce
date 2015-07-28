redirect = (response, url) ->
  response.writeHead(302, {
    'Location': url
  })
  response.end()


Router.route 'oauth2/sales-force/login', ->
  redirectUrl = App.Connectors.Salesforce.createOAuth2Credentials().getAuthorizationUrl {
    scope: 'full refresh_token'
  }

  redirect @response, redirectUrl

, {where: 'server'}