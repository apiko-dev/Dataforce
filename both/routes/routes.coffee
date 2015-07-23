Router.map ->
  @configure
    layoutTemplate: 'MasterLayout'
#    loadingTemplate: 'Loading'
#    notFoundTemplate: 'NotFound'
    yieldTemplates:
      'SidebarNavigation': {to: 'sidebar'}
      'Footer': {to: 'footer'}

  @route '/',
    name: 'home',
    template: 'Home'

  @route '/dashboard',
    name: 'dashboard',
    template: 'Dashboard'

  @route '/chart-editor',
    name: 'chartEditor',
    template: 'ChartEditor'


  @route '/google-analytics-sample',
    name: 'googleAnalyticsSample'
    action: ->
      if @params.query.code
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
