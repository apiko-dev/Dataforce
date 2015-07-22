Router.map ->
  @configure
    layoutTemplate: 'MasterLayout'
#    loadingTemplate: 'Loading'
#    notFoundTemplate: 'NotFound'
    yieldTemplates:
      'SampleNavigation': {to: 'header'}
  #      'Footer': {to: 'footer'}

  @route '/',
    name: 'home',
    template: 'Home'


  @route '/google-analytics-sample',
    name: 'googleAnalyticsSample'
    action: ->
      if @params.query.code
        console.log @params.query.code
        Meteor.call "GA.saveToken", @params.query.code, (err, result) ->
          Router.go "googleAnalyticsSample"
      else
        Meteor.call "GA.loadTokens", (err, result) ->
      @render 'googleAnalyticsSample'


  @route '/zendesk-example',
    name: 'zendeskExample',
    action: -> @render 'zendesk-example'


  @route '/sales-force-sample',
    name: 'salesForceSample',
    template: 'SalesForceSample'
    data: ->
      queryFields = ['accessToken', 'instanceUrl', 'userId']
      data = {}
      queryFields.forEach (key) => data[key] = @params.query[key]
      return data
