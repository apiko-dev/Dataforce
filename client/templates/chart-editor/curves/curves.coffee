Template.Curves.onCreated ->
  @newCurveId = ''
  @newCurves = new ReactiveVar false

Template.Curves.helpers
  newCurves: ->
    Template.instance().newCurves.get()

Template.Curves.events
  'click #new-curve': (event, tmpl) ->
    analytics.track 'Created new curve'
    tmpl.chartId = tmpl.get 'createdChartId'

    tmpl.newCurveId = Curves.insert {
      chartId: tmpl.chartId
      name: 'New curve'
      userId: Charts.findOne(_id: tmpl.chartId).userId
    }
    tmpl.newCurves.set Curves.find(chartId: Template.instance().chartId)
