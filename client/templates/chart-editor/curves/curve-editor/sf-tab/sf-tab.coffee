Template.SalesforceCurveEditorTab.onCreated ->
  @activePickerId = new ReactiveVar(false)

  tableSubscription = {
    instance: false
    tableName: false
  }

  @autorun =>
    console.log 'autorun'
    curve = Template.currentData()
    currentTableName = curve.metadata.name

    needChangeSubscription = not tableSubscription.instance or tableSubscription.tableName isnt currentTableName

    if currentTableName and needChangeSubscription
      if tableSubscription.instance then tableSubscription.instance.stop() #old subscription

      subscription = @subscribe 'salesforceTableFields', currentTableName
      tableSubscription =
        instance: subscription
        tableName: currentTableName

      console.log 'subscribed to ', tableSubscription


Template.SalesforceCurveEditorTab.helpers
  tables: -> SalesforceTables.find({}, {reactive: false}).fetch()

  tableColumns: ->
    entityName = @metadata?.name
    if entityName
      table = SalesforceTables.findOne({name: entityName})

      console.log 'table undefined' unless table

      if table then table.fields else []
    else []
