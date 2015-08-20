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

  @route '/sign-up/:inviteId',
    name: 'signUp',
    template: 'SignUp'
    data: ->
      inviteId: @params.inviteId

  @route '/sign-in',
    name: 'signIn',
    template: 'SignIn'

  @route '/dashboard',
    name: 'dashboard',
    template: 'Dashboard'
    waitOn: -> @subscribe 'userCharts'
    data: -> charts: Charts.find {}, {
      sort:
        createdAt: -1
    }

  @route '/chart-editor/:chartId',
    name: 'existingChartEditor',
    template: 'ChartEditor'
    waitOn: -> @subscribe 'chart', @params.chartId
    data: ->
      if @params.chartId
        Charts.findOne {_id: @params.chartId}

  @route '/chart-editor',
    name: 'chartEditor'
    template: 'Loading'
    onAfterAction: ->
      Charts.insert {
        name: 'New chart'
      }, App.handleError (chartId) =>
        @redirect 'existingChartEditor', {chartId: chartId}


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

  #todo: @vlad, this route should be renamed
  @route '/google-analytics-sample/_oauth/google',
    name: 'gaOAuth'
    action: ->
      if @params.query.code
        Meteor.call 'GA.saveToken', @params.query.code, (err, result) ->
          Router.go 'connectors'
    onAfterAction: -> Meteor.setTimeout (-> window.close()), 1000

  @route '/admin-panel',
    name: 'adminPanel'
    template: 'AdminPanel'


routePermissionDefaultAction = (context, conditionFn) ->
  if Meteor.isServer
    return context.next() #this check doesn't make sense on server side

  if conditionFn()
    context.next()
  else
    Router.go '/'


checkUserLoggedIn = ->
  routePermissionDefaultAction @, -> Meteor.loggingIn() or Meteor.user()


requireAdmin = ->
  routePermissionDefaultAction @, -> Roles.userIsInRole Meteor.userId(), ['admin']


requireTester = ->
  routePermissionDefaultAction @, -> Roles.userIsInRole Meteor.userId(), ['tester', 'admin']


# not signed users can visit only home page
Router.onBeforeAction checkUserLoggedIn, except: ['home', 'signIn', 'signUp']

#enable only testers access main app's functionality routes
Router.onBeforeAction requireTester, except: ['home', 'signIn', 'signUp']

Router.onBeforeAction requireAdmin, only: ['adminPanel']

