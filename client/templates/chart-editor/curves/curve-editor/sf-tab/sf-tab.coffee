Template.SalesforceCurveEditorTab.onCreated ->
  @isLoading = new ReactiveVar(false)
  @activePickerId = new ReactiveVar(false)

  @autorun =>
    curve = Template.currentData()
    currentTableName = curve.metadata.name
    if currentTableName
      @isLoading.set true
      @subscribe 'salesforceTableFields', currentTableName, => @isLoading.set false


Template.SalesforceCurveEditorTab.helpers
  tables: -> SalesforceTables.find({}, {reactive: false}).fetch()

  tableColumns: ->
    entityName = @metadata?.name
    if entityName
      table = SalesforceTables.findOne({name: entityName})

      console.log 'table undefined' unless table

      if table then table.fields else []
    else []

  isLoading: -> Template.instance().isLoading.get()
