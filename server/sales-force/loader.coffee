Meteor.methods
  sfUpdateTablesDescriptions: () ->
    userId = @userId
    describeTable = (tableName) ->
      tableMeta = App.SalesForce.Connector.runSyncQuery userId, 'describe', (conn) -> conn.sobject(tableName)
      tableMeta.fields.filter((field) ->
        App.SalesForce.isSupportedType(field.type)
      ).map (field) -> {name: field.name, type: field.type, label: field.label}


    unless App.isAdmin(@userId) then throw new Meteor.Error('401', 'Access denied')

    #clear old descriptions
    SalesforceTables.remove {}

    globalDescription = App.SalesForce.Connector.runSyncQuery @userId, 'describeGlobal', (conn) -> conn

    globalDescription.sobjects.forEach (table, i, arr) ->
      console.log "processing table #{table.name} #{i}/#{arr.length}"
      fields = describeTable table.name
      if fields.length > 1 and _.some(fields, (f) -> App.SalesForce.isNumberType(f.type))
        table =
          label: table.label
          name: table.name
          fields: fields
        SalesforceTables.insert table
      else
        console.log table.name, ' missed'


#Salesforce series loader
class SalesForceLoader
  getTableData: (curveMetadata) ->
#todo: implement filters here
    query = {}

    tableName = curveMetadata.name
    fields = "#{curveMetadata.metric.name}, #{curveMetadata.dimension.name}"
    queryFn = (conn) -> conn.sobject(tableName).find(query, fields).limit(50)
    App.SalesForce.Connector.runSyncQuery Meteor.userId(), 'execute', queryFn


  getDataForCurve: (curve) ->
    curveMetadata = curve.metadata

    if curveMetadata and curveMetadata.name and curveMetadata.metric and curveMetadata.dimension
      tableData = @getTableData curve.metadata

      #todo: data adapter dispatching
      dataAdapter = new App.SalesForce.RawGraph(curve, tableData)
      data = dataAdapter.getData()
      return data
    else
      return []


_.extend App.SalesForce,
  Loader: new SalesForceLoader()
