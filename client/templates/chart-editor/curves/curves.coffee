Template.Curves.onCreated ->
  @curveCreating = new ReactiveVar false

Template.Curves.helpers
  curveCreating: ->
    Template.instance().curveCreating.get()

  curvesList: [
    {caption: "Line", type: "line"}
    {caption: "Column", type: "line"}
    {caption: "Area", type: "area"}
    {caption: "Pie", type: "pie"}
  ]

Template.Curves.events
  "click #new-curve": (e, t) ->
    t.curveCreating.set true