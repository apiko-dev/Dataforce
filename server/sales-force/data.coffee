checkCredentialsAndCreateConnection = (userId) ->
#get credentials
  credentials = ServiceCredentials.findOne {userId: userId}, fields: {salesforce: 1}

  return App.Connectors.Salesforce.createConnection(credentials.salesforce)


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
    connection = checkCredentialsAndCreateConnection(@userId)

    processQueryResult connection.sobject(tableName), 'describe'


  sfGetTableData: (tableName, filters) ->
    check tableName, String
    check filters, [{
      field:
        name: String
        value: Match.Any
      modifier: FilterModifier
    }]
    connection = checkCredentialsAndCreateConnection(@userId)

    query = {}
    filters.forEach (filter) ->
      condition = {}
      condition[filter.modifier] = filter.field.value
      query[filter.field.name] = condition

    processQueryResult connection.sobject(tableName).find(query).limit(100), 'execute'