checkCredentialsAndCreateConnection = (userId) ->
#get credentials
  credentials = Connectors.findOne {userId: userId, name: ConnectorNames.Salesforce}

  return App.Connectors.Salesforce.createConnection(credentials.tokens)


processQueryResult = (query, functionName) ->
  queryResult = Async.runSync (done) -> query[functionName] done
  if queryResult.error then throw new Meteor.Error queryResult.error

  return queryResult.result


Meteor.methods
  sfDescribe: (tableName) ->
    check tableName, String
    connection = checkCredentialsAndCreateConnection(@userId)

    processQueryResult connection.sobject(tableName), 'describe'


  sfGetTableData: (tableName, filters) ->
    check tableName, String
    check filters, [App.checkers.Filter]
    connection = checkCredentialsAndCreateConnection(@userId)

    query = {}
    filters.forEach (filter) ->
      condition = {}
      condition[filter.modifier] = filter.field.value
      query[filter.field.name] = condition

    processQueryResult connection.sobject(tableName).find(query).limit(100), 'execute'


  sfGetSeriesForChart: (chart) ->
    check chart, App.checkers.Chart

    transformer = App.DataTransformers.SalesForceDataGrouper

    tableData = Meteor.call 'sfGetTableData', chart.table, chart.filters
    series = new transformer(chart, tableData)
    convertedSeries = series.getConvertedSeriesForHighchart()
    return convertedSeries

  sfGetConnectorEntries: () -> JSON.parse Assets.getText('sf/entities.json')
