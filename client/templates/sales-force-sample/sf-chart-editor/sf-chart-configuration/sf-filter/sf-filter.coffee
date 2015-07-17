Template.SalesForceChartDataFilter.onCreated ->
  @parentTemplate = @findParentTemplate('SalesForceChartConfiguration')


Template.SalesForceChartDataFilter.events
  'click .remove-filter-button': (event, tmpl) ->
    tmpl.parentTemplate.removeFilter(tmpl.data._id)

  'change .condition-field, blur .condition-value, change .is-not-equal-condition': (event, tmpl) ->
    filter =
      _id: tmpl.data._id
      key: tmpl.$('.condition-field').val()
      value: tmpl.$('.condition-value').val()
      isEqual: not tmpl.$('.is-not-equal-condition').is(":checked")

    tmpl.parentTemplate.updateFilter filter


