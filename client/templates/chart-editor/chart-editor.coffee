Template.ChartEditor.onCreated ->
  @chart = new ReactiveVar(@data and @data.chart)
  @axisX = new ReactiveVar {}
  @axisY = new ReactiveVar {}

  tmpl = Template.instance()
  Tracker.autorun ->
    console.log tmpl.axisX

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
      Charts.insert chart, App.handleError (chartId) =>
        @subscribe 'userChart', chartId,
          onReady: => @chart.set Charts.findOne {_id: chartId}

          onStop: App.handleError()


Template.ChartEditor.helpers
  sourcePickerModalConfig: ->
    tmpl = Template.instance()
    context: {}
    windowClass: 'dragable-big'
    backdrop: true
    onInitialize: (instance) ->
      tmpl.chartSourcePicker = instance


Template.ChartEditor.events
  'click .save-chart-button': (event, tmpl) ->
    tmpl.saveChart()

  'keyup .chart-name': (event, tmpl) ->
    tmpl.saveChart() if event.which is 13 #pressed enter

  'click .axis-chooser': (event, tmpl) ->
    chosenAxis = tmpl.$(event.target).data 'axis'
    if chosenAxis is 'x'
      tmpl.chartSourcePicker.show axis: tmpl.axisX
    else
      tmpl.chartSourcePicker.show axis: tmpl.axisY
