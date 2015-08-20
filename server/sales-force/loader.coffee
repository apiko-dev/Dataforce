checkCredentialsAndCreateConnection = (userId) ->
#get credentials
  credentials = App.SalesForce.Connector.getConnectorByUserId userId

  unless credentials then throw new Meteor.Error('500', 'You are not authenticated in Salesforce on "Connectors" page')

  return App.SalesForce.Connector.createConnection(credentials.tokens)


###
  Runs query synchronously

  @params:
  constructQueryFunc - function that receives connection instance and returns query ready for execution
  runQueryFuncName  - name of function that executes query instance
  userId - ID of current user
###
runSyncQuery = (userId, runQueryFuncName, constructQueryFunc) ->
  executeQuery = ->
    connection = checkCredentialsAndCreateConnection(userId)
    queryResult = Async.runSync (done) -> constructQueryFunc(connection)[runQueryFuncName](done)
    if queryResult.error
      if queryResult.error.name is 'invalid_grant' #we need to refresh token
        App.SalesForce.Connector.refreshToken(userId)
        return false
      else
        throw queryResult.error
    return queryResult.result

  result = executeQuery()
  if result is false #token was refreshed -> execute query again
    result = executeQuery()

  return result


Meteor.methods
  sfDescribe: (tableName) ->
    check tableName, String

    tableMeta = runSyncQuery @userId, 'describe', (conn) -> conn.sobject(tableName)

    tableMeta.fields?.map (field) -> {name: field.name, type: field.type, label: field.label}


  sfGetConnectorEntries: () -> JSON.parse Assets.getText('sf/entities.json')


#Salesforce series loader
Loader = {
  getTableData: (tableName, filters) ->
    check tableName, String
    check filters, [App.checkers.Filter]

    query = {}
    filters.forEach (filter) ->
      condition = {}
      condition[filter.modifier] = filter.field.value
      query[filter.field.name] = condition

    #todo: small optimisation: investigate column selection in order to reduce amount of traffic
    runSyncQuery @userId, 'execute', (conn) -> conn.sobject(tableName).find(query).limit(100)


  getSeriesForCurve: (curve) ->
    tableData = Loader.sfGetTableData curve.metadata.name, chart.filters

    #todo: data adapter dispatching
    dataAdapter = new App.SalesForce.RawGraph(curve.metadata, tableData)
    series = dataAdapter.getSeries()
    console.log series
    return series
}


_.extend App.SalesForce, {
  Loader: Loader
}