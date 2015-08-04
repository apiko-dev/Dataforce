checkCredentialsAndCreateConnection = (userId) ->
#get credentials
  credentials = App.Connectors.Salesforce.getConnectorByUserId userId

  return App.Connectors.Salesforce.createConnection(credentials.tokens)


processQueryResult = (query, functionName, userId) ->
  executeQuery = ->
    queryResult = Async.runSync (done) -> query[functionName] done
    if queryResult.error
      console.log queryResult.error.name

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

    connection = checkCredentialsAndCreateConnection(@userId)

    tableMeta = processQueryResult connection.sobject(tableName), 'describe', @userId
    tableMeta.fields.map (field) -> {name: field.name, type: field.type, label: field.label}


  sfGetTableData: (tableName, filters) ->
    check tableName, String
    check filters, [App.checkers.Filter]
    connection = checkCredentialsAndCreateConnection(@userId)

    query = {}
    filters.forEach (filter) ->
      condition = {}
      condition[filter.modifier] = filter.field.value
      query[filter.field.name] = condition

    processQueryResult connection.sobject(tableName).find(query).limit(100), 'execute', @userId


  sfGetSeriesForChart: (chart) ->
    check chart, App.checkers.Chart

    transformer = App.DataTransformers.SalesForceDataGrouper

    tableData = Meteor.call 'sfGetTableData', chart.table, chart.filters
    series = new transformer(chart, tableData)
    convertedSeries = series.getConvertedSeriesForHighchart()
    return convertedSeries

  sfGetConnectorEntries: () -> JSON.parse Assets.getText('sf/entities.json')
