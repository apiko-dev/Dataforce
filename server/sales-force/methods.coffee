createSalesForceConnection = (credentials) ->
  new jsforce.Connection({
    oauth2: {
      clientId: Meteor.settings.private.SalesForce.key
      clientSecret: Meteor.settings.private.SalesForce.secret
    }
    accessToken: credentials.accessToken
    instanceUrl: credentials.instanceUrl
  });


Meteor.methods
  testConnection: (credentials) ->
    check credentials, {
      accessToken: String
      instanceUrl: String
    }

    connection = createSalesForceConnection(credentials)

    queryResult = Async.runSync (done) ->
      connection.sobject("Contact").find({FirstName: {$like: 'A%'}}).limit(5).execute done

    if queryResult.error
      console.log queryResult.error
      return

    return queryResult.result