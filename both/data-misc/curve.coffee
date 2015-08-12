emptyCurveObject =
  name: 'New curve'
  chartId: ''
  type: 'line'
  metric:
    filterBy:
      fieldName: ''
      fieldValue: ''
      modifier: '$gt'
    orderBy:
      fieldName: ''
      direction: 0
    connectorId: ''
    entityName: ''
    fieldName: ''
  dimension:
    filterBy:
      fieldName: ''
      fieldValue: ''
      modifier: '$gt'
    orderBy:
      fieldName: ''
      direction: 0
    connectorId: ''
    entityName: ''
    fieldName: ''

_.extend App.DataMisc, {
  EmptyCurveObject: ->
    _.clone emptyCurveObject
}