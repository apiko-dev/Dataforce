Template.MetadataPickerListItem.onRendered ->
  @$(':radio').radiocheck()


Template.MetadataPickerListItem.onDestroyed ->
  @$(':radio').radiocheck('destroy')