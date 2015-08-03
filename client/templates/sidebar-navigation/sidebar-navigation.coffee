navigationMenuItems = [
  {name: 'home', caption: 'Home'}
  {name: 'dashboard', caption: 'Dashboard', requireLogin: true}
  {name: 'chartEditor', caption: 'Chart Editor', requireLogin: true}
  {name: 'connectors', caption: 'Connectors', requireLogin: true}
#    temp items
  {name: 'googleAnalyticsSample', caption: 'Google Analytics'}
  {name: 'zendeskExample', caption: 'Zendesk'}
  {name: 'salesForceSample', caption: 'Salesforce'}
]

Template.SidebarNavigation.helpers
  samplesRoutes: -> if Meteor.user() then navigationMenuItems else navigationMenuItems.filter (item) -> not item.requireLogin
