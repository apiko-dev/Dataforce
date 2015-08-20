#temporal series cap
randomData = ->
  data = [0..10].map (i) -> [i, Math.floor Math.random() * 100]
  console.log data
  return data


Meteor.methods
#in order to minimize data duplicating on the wire we will upload
#series for each curve separately
  'loadSeries': (curveId) ->
    check curveId, App.checkers.MongoId

    curve = Curves.findOne(_id: curveId)

    #check user's permissions
    App.checkPermissions(curve, Meteor.userId())

    #todo: remove redundant console logs
    console.log 'getting the series...'

    #Depending on curve source we run specific Data Adapters to get the right data

    #currently I'm sure only in Salesforce so
    #insted of other connectors we will use random mock data
    switch curve.source
      when ConnectorNames.GoogleAnalytics
#todo: check this code @vlad
#        console.log 'yay, google analytics is here'
#        gadl = new GoogleAnalyticsDataLoader(curve.metadata, curve.userId)
#        gada = new GoogleAnalyticsDataAdapter(curve, gadl.getJSON())
#        gada.getSeries()
        randomData()
      when ConnectorNames.Salesforce
        randomData()
      when ConnectorNames.Dataforce
        randomData()
      else
#       otherwise client got the error
        throw new Meteor.Error('404', 'We don\'t support this type of connector')

  'sanityTest': (n) ->
    check n, Number
    [0..n].map (i) -> [i, Math.floor Math.random() * 100]
