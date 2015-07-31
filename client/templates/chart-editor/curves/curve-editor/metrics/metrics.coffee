Template.Metrics.onCreated ->
  @searchPhrase = new ReactiveVar('')
  @mockMetrics = []
  @mockMetrics.push
    connectorName: "SF"
    metrics: [
      {name: 'Users'}
      {name: 'Accounts'}
      {name: 'Campaigns'}
      {name: 'Opportunities'}
    ]


Template.Metrics.helpers
#search stuff
  isMatchSearch: (target) ->
    searchPhrase = Template.instance().searchPhrase.get().toLowerCase()
    if searchPhrase.length > 0 then target.toLowerCase().indexOf(searchPhrase) > -1 else true

  metricMocks: ->
    gaMetricsList = ReactiveMethod.call "getGaMetricsList"
    if gaMetricsList then Template.instance().mockMetrics.push {connectorName: "GA", metrics: gaMetricsList}
    Template.instance().mockMetrics


Template.Metrics.events
  'keyup .metrics-search-input': (event, tmpl) ->
    text = tmpl.$('.metrics-search-input').val()
    tmpl.searchPhrase.set text
