Template.ChartEditor.onRendered ->
  userId = Meteor.userId()
  @createdChartId = Charts.insert
    userId: userId
    createdAt: moment().toDate()
    name: ''

  window.onbeforeunload = =>
    removeNewlyCreatedChart @
    if false then ''


Template.ChartEditor.onDestroyed ->
  removeNewlyCreatedChart @


Template.ChartEditor.onCreated ->
  @chart = new ReactiveVar(@data and @data.chart)
  @chartSaved = no

  @saveChart = =>
    #extract chart info
    chart = {
      userId: Meteor.userId(),
      name: @$('.chart-name').val()
    }

    editedChart = @chart.get()
    if editedChart
      Charts.update {_id: editedChart._id}, {$set: chart}, App.handleError =>
        @chart.set _.extend editedChart, chart
    else
      @chartSaved = yes
      Router.go 'dashboard'


Template.ChartEditor.events
  'click #load-series-button': (event, tmpl) ->
    Meteor.call 'loadSeries', tmpl.createdChartId

  'click .save-chart-button': (event, tmpl) ->
    tmpl.saveChart()
    analytics.track 'Saved new chart', {
      chartName: tmpl.$('.chart-name').val()
    }

  'keyup .chart-name': (event, tmpl) ->
    tmpl.saveChart() if event.which is 13 #pressed enter
    chartName = tmpl.$('.chart-name').val()

    Charts.update {_id: tmpl.createdChartId}, {
      $set:
        name: chartName
    }


removeNewlyCreatedChart = (tmpl) ->
  if not tmpl.chartSaved
    Charts.remove _id: tmpl.createdChartId