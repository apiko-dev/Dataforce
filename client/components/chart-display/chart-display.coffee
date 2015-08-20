###
  Displays chart by it's description
  Receives chart description as template context
###

Template.ChartDisplay.onCreated ->
  @series = new Mongo.Collection(null)

  loadSeriesForCurve = (curve, isUpdate) =>
    Meteor.call 'loadSeries', curve._id, App.handleError (series) =>
      console.log 'series', series
      seriesObj = {
        _id: curve._id
        name: curve.name
        data: series
        type: curve.type
      }
      unless isUpdate
        @series.insert seriesObj
      else
        delete seriesObj._id
        @series.update {_id: curve._id}, $set: seriesObj


  @autorun =>
    chart = Template.currentData()
    curves = Curves.find {chartId: chart._id}

    #clear old series
    @series.remove({})

    curves.observe
      added: (curve) => loadSeriesForCurve(curve)
      changed: (curve) => loadSeriesForCurve(curve, true)
      removed: (curve) => @series.remove {_id: curve._id}


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
