checkCredentialsAndCreateConnection = (userId) ->
#get credentials
  credentials = App.Connectors.Salesforce.getConnectorByUserId userId

  unless credentials then throw new Meteor.Error('500', 'You are not authenticated in Salesforce on "Connectors" page')

  return App.Connectors.Salesforce.createConnection(credentials.tokens)


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
        App.Connectors.Salesforce.refreshToken(userId)
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


  sfGetTableData: (tableName, filters) ->
    check tableName, String
    check filters, [App.checkers.Filter]

    query = {}
    filters.forEach (filter) ->
      condition = {}
      condition[filter.modifier] = filter.field.value
      query[filter.field.name] = condition

    runSyncQuery @userId, 'execute', (conn) -> conn.sobject(tableName).find(query).limit(100)


  sfGetSeriesForChart: (chart) ->
    check chart, App.checkers.Chart

    transformer = App.DataTransformers.SalesForceDataGrouper

    tableData = Meteor.call 'sfGetTableData', chart.table, chart.filters
    series = new transformer(chart, tableData)
    convertedSeries = series.getConvertedSeriesForHighchart()
    return convertedSeries

  sfGetConnectorEntries: () -> JSON.parse Assets.getText('sf/entities.json')


