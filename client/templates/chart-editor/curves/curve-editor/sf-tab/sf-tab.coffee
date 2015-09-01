Template.SalesforceCurveEditorTab.onCreated ->
  @isLoading = new ReactiveVar(false)
  @activePickerId = new ReactiveVar(false)

  spinnerVisibility = (visible) => @isLoading.set visible

  @autorun =>
    curve = Template.currentData()
    curveMetadata = curve.metadata
    if curveMetadata and curveMetadata.name
      currentTableName = curveMetadata.name
      spinnerVisibility(true)
      sub = @subscribe 'salesforceTableFields', currentTableName, => spinnerVisibility(false)
      if sub.ready() then spinnerVisibility(false)


Template.SalesforceCurveEditorTab.helpers
  tables: -> SalesforceTables.find({}, {reactive: false}).fetch()

  tableColumns: ->
    entityName = @metadata?.name
    if entityName
      table = SalesforceTables.findOne({name: entityName})
      if table then table.fields else []
    else []

  isLoading: -> Template.instance().isLoading.get()
