Template.SalesforceCurveEditorTab.onCreated ->
  @activePickerId = new ReactiveVar(false)

  @autorun =>
    t = @activePickerId.get()
    console.log 'value changed ', t


Template.SalesforceCurveEditorTab.helpers
  tables: -> ReactiveMethod.call 'sfGetConnectorEntries'
