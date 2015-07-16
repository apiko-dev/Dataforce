createSalesForceConnection = (credentials) ->
  new jsforce.Connection({
    oauth2: {
      clientId: Meteor.settings.private.SalesForce.key
      clientSecret: Meteor.settings.private.SalesForce.secret
    }
    accessToken: credentials.accessToken
    instanceUrl: credentials.instanceUrl
  })


checkCredentialsAndCreateConnection = (credentials) ->
  check credentials, {
    accessToken: String
    instanceUrl: String
  }
  return createSalesForceConnection(credentials)


Meteor.methods
  sfDescribe: (credentials, tableName) ->
    connection = checkCredentialsAndCreateConnection(credentials)
    check tableName, String

    queryResult = Async.runSync (done) ->
      connection.sobject(tableName).describe done

    if queryResult.error then throw new Meteor.Error queryResult.error

    return queryResult.result


#demo example method
  getOpportunities: (credentials) ->
    connection = checkCredentialsAndCreateConnection(credentials)
    queryResult = Async.runSync (done) ->
      connection.sobject("Opportunity").find({}).sort({CloseDate: -1}).limit(50).execute done

    if queryResult.error then throw new Meteor.Error queryResult.error

    return queryResult.result
