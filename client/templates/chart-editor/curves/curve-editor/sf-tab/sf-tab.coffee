Template.SalesforceCurveEditorTab.onCreated ->
  @activePickerId = new ReactiveVar(false)

  @autorun =>
    curve = Template.currentData()
    currentTableName = curve.metadata.name
    if currentTableName
      @subscribe 'salesforceTableFields', currentTableName


Template.SalesforceCurveEditorTab.helpers
  tables: -> SalesforceTables.find({}, {reactive: false}).fetch()

  tableColumns: ->
    entityName = @metadata?.name
    if entityName
      table = SalesforceTables.findOne({name: entityName})

      console.log 'table undefined' unless table

      if table then table.fields else []
    else []
