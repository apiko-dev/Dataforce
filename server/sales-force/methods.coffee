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


  onSalesForceLogin: (authCode) ->
    check authCode, String

    userId = Meteor.userId()

    conn = new jsforce.Connection
      oauth2: App.Connectors.Salesforce.createOAuth2Credentials()

    authorizeAsync = Meteor.wrapAsync conn.authorize, conn

    authorizeAsync authCode, (err, userInfo) =>
      if err
        console.error(err)
      else
        mapAuthParams = (connection) ->
          params = {}
          [
            'accessToken'
            'instanceUrl'
            'refreshToken'
          ].forEach (key) -> params[key] = connection[key]
          return params

        authParams = mapAuthParams conn

        sfServiceCredentials = _.extend {userId: userId}, {salesforce: authParams}

        #save credentials
        ServiceCredentials.update {userId: userId}, {$set: sfServiceCredentials}, {upsert: true}
