###
  Displays chart by it's description
  Receives chart description as template context
###

Template.ChartDisplay.onCreated ->
#todo remove it after adding real series loading
#temporal series cap
  randomData = (curve) ->
    _id: curve._id
    data: [0..10].map (i) -> [i, Math.floor Math.random() * 100]
    name: curve.name

  @series = new Mongo.Collection(null)
  @autorun =>
    chart = Template.currentData()
    curves = Curves.find {chartId: chart._id}

    #clear old series
    @series.remove({})

    curves.observe
      added: (curve) =>
        console.log 'new curve', curve
        @series.insert randomData(curve)
      changed: (curve) =>
        console.log 'updated curve', curve
        newData = randomData(curve)
        delete newData._id
        @series.update {_id: curve._id}, {$set: newData}
      removed: (curve) =>
        console.log 'curve removed', curve
        @series.remove {_id: curve._id}


Template.ChartDisplay.onRendered ->
  @autorun =>
    chart = Template.currentData()
    series = @series.find({}).fetch()
    @$(".highchart-chart").highcharts defaultChartOptions chart.name, series


defaultChartOptions = (title, series) ->
  chart:
    type: 'column'
  title:
    text: title
  yAxis:
    min: 0,
  plotOptions:
    column:
      pointPadding: 0.2,
      borderWidth: 0
  series: series
