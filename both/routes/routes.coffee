Router.map ->
  @configure
    layoutTemplate: 'MasterLayout'
    loadingTemplate: 'Loading'
    notFoundTemplate: 'NotFound'
    yieldTemplates:
      'SidebarNavigation': {to: 'sidebar'}
      'Footer': {to: 'footer'}

  @route '/',
    name: 'home',
    template: 'Home'

  @route '/dashboard',
    name: 'dashboard',
    template: 'Dashboard'
    waitOn: -> @subscribe 'userCharts'
    data: -> charts: Charts.find()

  @route '/chart-editor/:chartId',
    name: 'existingChartEditor',
    template: 'ChartEditor'
    waitOn: -> @subscribe 'userChart', @params.chartId
    data: ->
      if @params.chartId
        chart: Charts.findOne {_id: @params.chartId}

  @route '/chart-editor',
    name: 'chartEditor',
    template: 'ChartEditor'

  @route '/connectors',
    name: 'connectors',
    template: 'Connectors'

  @route 'oauth2/sales-force/callback',
    name: 'salesForceCallback'
    template: 'AuthSuccess'
    data: ->
      Meteor.call 'onSalesForceLogin', @params.query.code, App.handleError()
      serviceName: 'SalesForce'
    onAfterAction: -> Meteor.setTimeout (-> window.close()), 1000


  #  =====  SAMPLES  ====

  @route '/google-analytics-sample',
    name: 'googleAnalyticsSample'
    template: 'googleAnalyticsSample'

  @route '/google-analytics-sample/_oauth/google',
    name: 'gaOAuth'
    action: ->
      if @params.query.code
        Meteor.call 'GA.saveToken', @params.query.code, (err, result) ->
          Router.go 'connectors'

  @route '/zendesk-example',
    name: 'zendeskExample',
    template: 'zendeskExample'

  @route '/sales-force-sample',
    name: 'salesForceSample',
    template: 'SalesForceSample'

Router.onAfterAction ->
  Meteor.call 'GA.loadTokens'