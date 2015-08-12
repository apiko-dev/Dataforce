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
    analytics.track 'Created new curve', {
      curveName: tmpl.$('.curve-title').val()
    }
    tmpl.curveCreating.set true
    tmpl.newCurves.get().push 0
    tmpl.newCurves.set tmpl.newCurves.get()