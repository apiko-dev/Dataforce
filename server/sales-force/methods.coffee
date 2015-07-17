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


processQueryResult = (query, functionName) ->
  queryResult = Async.runSync (done) -> query[functionName] done
  if queryResult.error then throw new Meteor.Error queryResult.error
  return queryResult.result


Meteor.methods
  sfDescribe: (credentials, tableName) ->
    connection = checkCredentialsAndCreateConnection(credentials)
    check tableName, String

    processQueryResult connection.sobject(tableName), 'describe'


  sfGetTableData: (credentials, tableName, filters) ->
    connection = checkCredentialsAndCreateConnection(credentials)
    check tableName, String
    check filters, [{
      key: String
      value: String
      isEqual: Boolean
    }]
#todo finish this method


#demo example method
  getOpportunities: (credentials) ->
    connection = checkCredentialsAndCreateConnection(credentials)

    processQueryResult connection.sobject("Opportunity").find({}).sort({CloseDate: -1}).limit(50), 'execute'