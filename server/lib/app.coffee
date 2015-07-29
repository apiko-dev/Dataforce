#==== global application's object for server side ====


_App = {
  checkers:
    MongoId: Match.Where (id) ->
      check id, String
      return /[0-9a-zA-Z]{17}/.test(id)


    FilterModifier: Match.Where (x) ->
      check(x, String)
      return x in ['$gt', '$eq', '$lt', '$lte', '$gte', '$ne']


    ValueFunction: Match.Where (x) ->
      check(x, String)
      return x in ['sum', 'average', 'multiply']


    Filter: Match.Where (x) ->
      check x,
        field:
          name: String
          value: Match.Any
        modifier: FilterModifier
      return true


    Chart: Match.Where (x) ->
      check x,
        table: String
        filters: [Filter]
        valueFunction: ValueFunction
        axis:
          metrics: String
          dimension: String
          dimension2: Match.OneOf String, null
      return true
}


_.extend App, _App

