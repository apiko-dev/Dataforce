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


FilterModifier = Match.Where (x) ->
  check(x, String)
  return x in ['$gt', '$eq', '$lt', '$lte', '$gte', '$ne']


Meteor.methods
  sfDescribe: (tableName) ->
    check tableName, String
    connection = checkCredentialsAndCreateConnection()

    processQueryResult connection.sobject(tableName), 'describe'


  sfGetTableData: (tableName, filters) ->
    check tableName, String
    check filters, [{
      field:
        name: String
        value: Match.Any
      modifier: FilterModifier
    }]
    connection = checkCredentialsAndCreateConnection()

    query = {}
    filters.forEach (filter) ->
      condition = {}
      condition[filter.modifier] = filter.field.value
      query[filter.field.name] = condition

    console.log query

    processQueryResult connection.sobject(tableName).find(query).limit(100), 'execute'