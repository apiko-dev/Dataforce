class ZendeskDataTransformer
  constructor: (@numeralValueToGet, @json) ->

  getNumeralValue: ->
    switch @numeralValueToGet
      when App.DataMisc.ZendeskQueries.OPENED_TICKETS
        @json.length

  getSeries: ->

    switch @numeralValueToGet
      when App.DataMisc.ZendeskQueries.OPENED_TICKETS
        @json.length

_.extend App.DataTransformers, {
  Zendesk: ZendeskDataTransformer
}