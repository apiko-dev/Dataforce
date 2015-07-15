Meteor.methods
  testConnection: ->
    credentials = JSON.parse Assets.getText 'sf-api.json'
    console.log credentials

    sfdcConnection = new jsforce.Connection({
      oauth2: {clientId: credentials.key, clientSecret: credentials.secret}
    });

    sfdcConnection.login credentials.login, credentials.password, (err, userInfo) ->
      console.log err, userInfo
#      sfdcConnection.sobject("Contact").find({LastName: {$like: 'A%'}}).limit(5).execute (err, records) ->
#        if (err)
#          console.error(err)
#        else
#          console.log "fetched : " + records.length