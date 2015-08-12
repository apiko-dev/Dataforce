Template.ChartEditor.onRendered ->
  Charts.insert
    userId: Meteor.userId()
    name: ''

Template.ChartEditor.onCreated ->
  @chart = new ReactiveVar(@data and @data.chart)
  @axisX = new ReactiveVar {type: 'x'}
  @axisY = new ReactiveVar {type: 'y'}

  tmpl = Template.instance()

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
    analytics.track 'Saved new chart', {
      chartName: tmpl.$('.chart-name').val()
    }

  'keyup .chart-name': (event, tmpl) ->
    tmpl.saveChart() if event.which is 13 #pressed enter

  'click .axis-chooser': (event, tmpl) ->
    chosenAxis = getChosenAxis(event, tmpl)

    if chosenAxis is 'x'
      tmpl.chartSourcePicker.show axis: tmpl.axisX
    else
      tmpl.chartSourcePicker.show axis: tmpl.axisY

getChosenAxis = (event, tmpl) ->
  clickedOnChild = event.target.tagName is 'SPAN'
  if clickedOnChild
    tmpl.$(event.target).parent().data 'axis'
  else
    tmpl.$(event.target).data 'axis'