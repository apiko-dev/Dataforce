Template.DfMetadataPickerListItem.onRendered ->
  parentData = Template.parentData(1)

  @$(':radio').radiocheck()

  #restore picker value
  if parentData.doc.metadata?[parentData.propertyName] is @data._id
    @$(':radio').radiocheck('check')


Template.DfMetadataPickerListItem.onDestroyed ->
  @$(':radio').radiocheck('destroy')