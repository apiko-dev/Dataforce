Template.SalesForceChartConfiguration.onCreated ->
  @filters = new Mongo.Collection(null)

  @filters.deny
    update: -> false

  @removeFilter = (filterId) => @filters.remove {_id: filterId}


  @updateFilter = (filter) =>
    id = filter._id
    delete filter._id
    @filters.update {_id: id}, {$set: filter}


Template.SalesForceChartConfiguration.helpers
  numberFields: -> @fields.filter (field) -> field.type in ['int', 'double', 'currency', 'percent']

  filters: -> Template.instance().filters.find({})

  valueFunctions: -> [
    {name: 'sum', label: 'Sum'}
    {name: 'average', label: 'Average'}
    {name: 'multiply', label: 'Multiply'}
  ]


Template.SalesForceChartConfiguration.events
  'click .apply-chart-button': (event, tmpl) ->
    chart = {
      table: tmpl.data.table
      filters: tmpl.filters.find({}, {fields: {_id: 0}}).fetch() #comming soon...
      valueFunction: tmpl.$('#value-function-field').val()
      axes:
        metrics: tmpl.$('#metrics-field').val()
        dimensions: tmpl.$('#dimension-field').val()
        dimensions2: tmpl.$('#dimension2-field').val()
    }
    #    console.log 'chart ', chart
    Session.set('sfChart', chart)


  'click .add-new-condition': (event, tmpl) ->
    tmpl.filters.insert {}