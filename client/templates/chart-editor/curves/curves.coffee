Template.Curves.onCreated ->
  @curveCreating = new ReactiveVar false
  @newCurves = new ReactiveVar []

Template.Curves.helpers
  curveCreating: ->
    Template.instance().curveCreating.get()

  newCurves: ->
    Template.instance().newCurves.get()

Template.Curves.events
  'click #new-curve': (event, tmpl) ->
    analytics.track 'Created new curve'
    tmpl.curveCreating.set true
    tmpl.newCurves.get().push 0
    tmpl.newCurves.set tmpl.newCurves.get()

    chartId = tmpl.get('createdChartId')
    Curves.insert {
      chartId: chartId
      userId: Charts.findOne(_id: chartId).userId
      metric: {}
      dimension: {}
    }