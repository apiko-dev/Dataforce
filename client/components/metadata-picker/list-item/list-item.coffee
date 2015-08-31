Template.SfMetadataPickerListItem.onRendered ->
  @$(':radio').radiocheck()


Template.SfMetadataPickerListItem.onDestroyed ->
  @$(':radio').radiocheck('destroy')