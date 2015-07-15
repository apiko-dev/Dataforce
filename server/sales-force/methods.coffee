createSalesForceConnection = (credentials) ->
  new jsforce.Connection({
    oauth2: {
      clientId: Meteor.settings.private.SalesForce.key
      clientSecret: Meteor.settings.private.SalesForce.secret
    }
    accessToken: credentials.accessToken
    instanceUrl: credentials.instanceUrl
  });


Meteor.methods
  testConnection: (credentials) ->
    check credentials, {
      accessToken: String
      instanceUrl: String
    }

    connection = createSalesForceConnection(credentials)

    query = connection.sobject("Contact").find({FirstName: {$like: 'A%'}}).limit(5)

    asyncExecute = Meteor.wrapAsync(query.execute, query)

    records = asyncExecute (err, records) ->
      if (err)
        throw new Meteor.Error(err)
      else
        return records

    return records