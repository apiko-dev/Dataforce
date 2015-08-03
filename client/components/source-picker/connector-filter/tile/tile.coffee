Template.ConnectorFilterTile.onRendered ->
  @$('.enable-connector').bootstrapSwitch()


Template.ConnectorFilterTile.events
  'click .configure-source': (event, tmpl) ->
    tmpl.findParentTemplate('SourcePicker').showEntityPickerFor(tmpl.data)

  'switchChange.bootstrapSwitch .enable-connector': (event, tmpl, state) ->



Template.ConnectorFilterTile.onDestroyed ->
  @$('.enable-connector').bootstrapSwitch('destroy')

