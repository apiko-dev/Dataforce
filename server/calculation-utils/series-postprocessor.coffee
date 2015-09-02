class @SeriesPostprocessor
  ###
    Global class for series processing
    Adds min & max values and also normalizes data if needed
  ###
  @_seriesMinAndMax: (series) ->
    min = false
    max = false
    series.data.forEach (point) ->
      metricValue = point.y
      if min is false or metricValue < min then min = metricValue
      if max is false or metricValue > max then max = metricValue
    _.extend series, {min: min, max: max}


  @_normalize: (series) ->
    @_seriesMinAndMax(series)
    series.data.forEach (point) -> point.y = point.y / series.max


  @_convertDate: (series) ->
    if series.curve.metadata.dimension.type is 'date'
      series.data.forEach (point) ->
        point.x = new Date(point.x).valueOf()

      series.data.sort (a, b) -> a.x - b.x


  ###
    Series postprocessing method
      @args
      curve - object
      data - array of data points
      @returns series based on curve and it's data
  ###
  @process: (curve, data) ->
#    copy curve
    curve = _.extend {}, curve
    series =
      name: curve.name
      type: curve.type
      data: data
      curve: curve

    #remove duplicated fields
    delete curve.type
    delete curve.name

    #connector specific processing here
    #Salesforce specific processing
    if curve.source is ConnectorNames.Salesforce
      @_convertDate(series) #convert dimension to date if it has date type

    #common processing jobs
    if curve.normalize then @_normalize(series)
    #find actual min and max
    @_seriesMinAndMax(series)

    return series

