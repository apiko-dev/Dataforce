Template.Curves.onCreated ->
  @curveCreating = new ReactiveVar false
  @newCurves = new ReactiveVar []

Template.Curves.helpers
  curveCreating: ->
    Template.instance().curveCreating.get()

  newCurves: ->
    Template.instance().newCurves.get()

Template.Curves.events
  "click #new-curve": (e, t) ->
    t.curveCreating.set true
    t.newCurves.get().push 0
    t.newCurves.set t.newCurves.get()