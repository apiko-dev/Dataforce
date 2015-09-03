class CurveSourceCheckers
  @Salesforce: (curve) ->
    curveMetadata = curve.metadata
    curveMetadata and curveMetadata.name and curveMetadata.metric and curveMetadata.dimension

  @Dataforce: (curve) ->
    curveMetadata = curve.metadata
    curveMetadata and curveMetadata.dimension and curveMetadata.metric and curveMetadata.delta


onCurvesChange = (userId, curve) ->
  saveSeriesObject = (data) ->
    series = SeriesPostprocessor.process(curve, data) #makes normalizing & addes min/max values
    Series.update {curveId: curve._id}, {$set: series}, {upsert: true}

  #todo: temporal series cap - remove after implementing real services
  randomData = -> [0..10].map (i) -> {x: i, y: (Math.floor Math.random() * 100) * 1000}
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
      if CurveSourceCheckers.Salesforce(curve)
        data = App.SalesForce.Loader.getDataForCurve(curve)
        saveSeriesObject(data)
    when ConnectorNames.Dataforce
      if CurveSourceCheckers.Dataforce(curve)
        data = App.Dataforce.Adapter.generateCurveSeries(curve)
        saveSeriesObject(data)
    else
      console.log "Requested source do not supported: #{curve.source}"

  #notify other curves about change if they depend on this curve
  Curves.find({
    chartId: curve.chartId,
    $or: [
      {'metadata.dimension': curve._id}
      {'metadata.metric': curve._id}
    ]
  }).forEach (changedCurve) -> onCurvesChange(userId, changedCurve)


#initialize collection's hooks
Curves.after.insert onCurvesChange
Curves.after.update onCurvesChange
Curves.after.remove (userId, doc) -> Series.remove {curveId: doc._id}

