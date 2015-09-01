Template.MetadataPickerListItem.onRendered ->
  @$(':radio').radiocheck()

  currentPickerValue = @get('getDocumentProperty')()?.name

  #restore picker value
  if currentPickerValue is @data.name
    @$(':radio').radiocheck('check')


Template.MetadataPickerListItem.onDestroyed ->
  @$(':radio').radiocheck('destroy')