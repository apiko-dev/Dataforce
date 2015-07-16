Template.SalesForceChartEditor.onCreated ->
  @currentTable = new ReactiveVar(false)
  @fields = new ReactiveVar(false)


Template.SalesForceChartEditor.helpers
  currentTable: -> Template.instance().currentTable.get()
  fields: -> Template.instance().fields.get()


Template.SalesForceChartEditor.events
  'change #table-dropdown': (event, tmpl) ->
    tableName = tmpl.$('#table-dropdown').val()

    #get table meta
    credentials = tmpl.findParentTemplate('SalesForceSample').getCredentials()

    if tableName isnt 'none'
      Meteor.call 'sfDescribe', credentials, tableName, (err, tableMeta) ->
        fields = tableMeta.fields.map (field) -> {name: field.name, type: field.type, label: field.label}

        #prints unique types of table's meta
        #types = []
        #tableMeta.fields.forEach (field) -> unless field.type in types then types.push(field.type)
        #console.log types.join(', ')

        tmpl.fields.set fields
        tmpl.currentTable.set tableName
    else
      tmpl.currentTable.set false
