checkCredentialsAndCreateConnection = (userId) ->
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

    App.SalesForce.Connector.updateApiUsage(userId, connection.limitInfo.apiUsage)

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

  sfUpdateTablesDescriptions: () ->
    unless App.isAdmin(@userId) then throw new Meteor.Error('401', 'Access denied')

    #clear old descriptions
    SalesforceTables.remove {}

    globalDescription = runSyncQuery @userId, 'describeGlobal', (conn) -> conn

    globalDescription.sobjects.forEach (table, i, arr) ->
      console.log "processing table #{table.name} #{i}/#{arr.length}"
      fields = Meteor.call 'sfDescribe', table.name
      table = {
        label: table.label,
        name: table.name,
        fields: fields.filter (field) -> App.SalesForce.isSupportedType(field.type)
      }
      if table.fields.length > 0
        SalesforceTables.insert table
      else console.log table.name, ' missed'


#Salesforce series loader
Loader = {
  getTableData: (curveMetadata) ->
#todo: implement filters here
    query = {}

    tableName = curveMetadata.name
    fields = "#{curveMetadata.metric.name}, #{curveMetadata.dimension.name}"
    runSyncQuery Meteor.userId(), 'execute', (conn) -> conn.sobject(tableName).find(query, fields).limit(50)


  getSeriesForCurve: (curve) ->
    curveMetadata = curve.metadata

    if curveMetadata and curveMetadata.name and curveMetadata.metric and curveMetadata.dimension
      tableData = Loader.getTableData curve.metadata

      #todo: data adapter dispatching
      dataAdapter = new App.SalesForce.RawGraph(curve.metadata, tableData)
      series = dataAdapter.getSeries()
      return series
    else
      return []
}


_.extend App.SalesForce, {
  Loader: Loader
}