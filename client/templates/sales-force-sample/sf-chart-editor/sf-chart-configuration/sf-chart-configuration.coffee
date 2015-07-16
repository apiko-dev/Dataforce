Template.SalesForceChartConfiguration.onCreated ->


Template.SalesForceChartConfiguration.helpers
  numberFields: -> @fields.filter (field) -> field.type in ['int', 'double', 'currency', 'percent']