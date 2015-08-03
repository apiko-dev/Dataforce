Template.SalesForceChartEditor.onCreated ->
  @currentTable = new ReactiveVar(false)
  @fields = new ReactiveVar(false)


Template.SalesForceChartEditor.helpers
  currentTable: -> Template.instance().currentTable.get()
  fields: -> Template.instance().fields.get()


Template.SalesForceChartEditor.events
  'change #table-dropdown': (event, tmpl) ->
    tableName = tmpl.$('#table-dropdown').val()

    if tableName isnt 'none'
      Meteor.call 'sfDescribe', tableName, App.handleError (fields) ->

#prints unique types of table's meta
#types = []
#tableMeta.fields.forEach (field) -> unless field.type in types then types.push(field.type)
#console.log types.join(', ')
        tmpl.fields.set fields
        tmpl.currentTable.set tableName
    else
      tmpl.currentTable.set false
