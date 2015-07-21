Template.SalesForceChartDataFilter.onCreated ->
  @parentTemplate = @findParentTemplate('SalesForceChartConfiguration')


Template.SalesForceChartDataFilter.helpers
  modifiers: -> [
    {value: '$gt', description: 'Greater'}
    {value: '$eq', description: 'Equal'}
    {value: '$lt', description: 'Less'}
    {value: '$lte', description: 'Less-equal'}
    {value: '$gte', description: 'Greater-equal'}
    {value: '$ne', description: 'Not equal'}
  ]

Template.SalesForceChartDataFilter.events
  'click .remove-filter-button': (event, tmpl) ->
    tmpl.parentTemplate.removeFilter(tmpl.data._id)

  'change .condition-field, blur .condition-value, change .is-not-equal-condition': (event, tmpl) ->
    filter =
      _id: tmpl.data._id
      field:
        name: tmpl.$('.condition-field').val()
        value: tmpl.$('.condition-value').val()
      modifier: tmpl.$('.filter-modifier').val()

    tmpl.parentTemplate.updateFilter filter


