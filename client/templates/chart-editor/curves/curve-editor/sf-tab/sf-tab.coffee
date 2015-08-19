tables = false

Template.SalesforceCurveEditorTab.onCreated ->
  @activePickerId = new ReactiveVar(false)


Template.SalesforceCurveEditorTab.helpers
  tables: ->
    unless tables
      tables = ReactiveMethod.call 'sfGetConnectorEntries'
    return tables

  tableColumns: ->
    entityName = @metadata?.name
    if entityName then ReactiveMethod.call 'sfDescribe', entityName else []
