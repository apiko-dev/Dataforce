onCurvesChange = (userId, curve) ->
  saveSeriesObject = (data) ->
    series = SeriesPostprocessor.process(curve, data)
    Series.update {curveId: curve._id}, {$set: series}, {upsert: true}

  #todo: temporal series cap - remove after implementing real services
  randomData = -> [0..10].map (i) -> [i, (Math.floor Math.random() * 100) * 1000]
  saveSeriesUsingMockData = -> saveSeriesObject randomData()
  #end of mock data generator

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
      saveSeriesUsingMockData()
    when ConnectorNames.Salesforce
      data = App.SalesForce.Loader.getDataForCurve(curve)
      saveSeriesObject(data)
    when ConnectorNames.Dataforce
      saveSeriesUsingMockData()
    else
      console.log "Requested source do not supported: #{curve.source}"


#initialize collection's hooks
Curves.after.insert onCurvesChange
Curves.after.update onCurvesChange
Curves.after.remove (userId, doc) -> Series.remove {curveId: doc._id}

