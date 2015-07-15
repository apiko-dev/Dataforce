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
        Meteor.call "saveGAToken", @params.query.code, (err, result) ->
          Router.go "googleAnalyticsSample"
      @render 'googleAnalytics'


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
