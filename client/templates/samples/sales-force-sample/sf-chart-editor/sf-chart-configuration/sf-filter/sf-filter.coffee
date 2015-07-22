modifiers = [
  {value: '$eq', description: 'Equal'}
  {value: '$ne', description: 'Not equal'}
  {value: '$gt', description: 'Greater'}
  {value: '$lt', description: 'Less'}
  {value: '$lte', description: 'Less-equal'}
  {value: '$gte', description: 'Greater-equal'}
]

Template.SalesForceChartDataFilter.onCreated ->
  @parentTemplate = @findParentTemplate('SalesForceChartConfiguration')
  @isSelectedFieldNumber = new ReactiveVar(false)


Template.SalesForceChartDataFilter.helpers
  modifiers: ->
    if Template.instance().isSelectedFieldNumber.get()
      modifiers
    else
#other types can suppport only 'equal' and 'not equal'
      modifiers.filter (m) -> m.value in ['$eq', '$ne']


Template.SalesForceChartDataFilter.events
  'click .remove-filter-button': (event, tmpl) ->
    tmpl.parentTemplate.removeFilter(tmpl.data._id)


  'change .condition-field, blur .condition-value, change .is-not-equal-condition': (event, tmpl) ->
    fieldName = tmpl.$('.condition-field').val()

    #to find out field's type
    selectedField = (Template.parentData(1).fields.filter (field) -> field.name is fieldName)[0]

    fieldValue = tmpl.$('.condition-value').val()
    #find out if we need convert field value to number
    isNumberField = selectedField and App.DataAdapters.SalesForce::isNumberType selectedField.type

    tmpl.isSelectedFieldNumber.set isNumberField

    if isNumberField
      convertedValue = Number fieldValue

      if convertedValue is NaN
        alert 'Field\'s value should be a number'
        return
      else
        fieldValue = convertedValue


    filter =
      _id: tmpl.data._id
      field:
        name: fieldName
        value: fieldValue
      modifier: tmpl.$('.filter-modifier').val()

    tmpl.parentTemplate.updateFilter filter


