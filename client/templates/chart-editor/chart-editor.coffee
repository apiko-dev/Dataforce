Template.ChartEditor.onCreated ->
  @currentChart = null


Template.ChartEditor.events
  'click .save-chart-button': (event, tmpl) ->
#extract chart info
    chart = {
      userId: Meteor.userId(),
      name: tmpl.$('.chart-name').val()
    }

    #save chart
    unless tmpl.currentChart
      Charts.insert chart, App.handleError (chartId) ->
        tmpl.currentChart = Charts.findOne {_id: chartId}
    else
      Charts.update {_id: tmpl.currentChart._id}, {$set: chart}, App.handleError ->
        _.extend tmpl.currentChart, chart
