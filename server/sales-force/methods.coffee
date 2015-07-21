createSalesForceConnection = (credentials) ->
  new jsforce.Connection({
    oauth2: {
      clientId: Meteor.settings.private.SalesForce.key
      clientSecret: Meteor.settings.private.SalesForce.secret
    }
    accessToken: credentials.accessToken
    instanceUrl: credentials.instanceUrl
  })


checkCredentialsAndCreateConnection = ->
  #get credentials
  credentials = ServiceCredentials.findOne {userId: App.temp.defaultUserId}, fields: {salesforce: 1}

  return createSalesForceConnection(credentials.salesforce)


processQueryResult = (query, functionName) ->
  queryResult = Async.runSync (done) -> query[functionName] done
  if queryResult.error then throw new Meteor.Error queryResult.error
  return queryResult.result


Meteor.methods
  sfDescribe: (tableName) ->
    check tableName, String
    connection = checkCredentialsAndCreateConnection()

    processQueryResult connection.sobject(tableName), 'describe'


  sfGetTableData: (tableName, filters) ->
    check tableName, String
    check filters, [{
      key: String
      value: String
      isEqual: Boolean
    }]
    connection = checkCredentialsAndCreateConnection()

    query = {}
    filters.forEach (filter) -> query[filter.key] = if filter.isEqual then filter.value else {$ne: filter.value}

    processQueryResult connection.sobject(tableName).find(query).limit(100), 'execute'