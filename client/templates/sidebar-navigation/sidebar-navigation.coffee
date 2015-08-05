navigationMenuItems = [
  {name: 'home', caption: 'Home'}
  {name: 'dashboard', caption: 'Dashboard', requireLogin: true}
  {name: 'chartEditor', caption: 'Chart Editor', requireLogin: true}
  {name: 'connectors', caption: 'Connectors', requireLogin: true}
]

Template.SidebarNavigation.helpers
#todo remove after adding invites
  samplesRoutes: -> if Meteor.user() and App.checkAdmin() then navigationMenuItems else navigationMenuItems.filter (item) -> not item.requireLogin
