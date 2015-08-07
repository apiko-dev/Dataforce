navigationMenuItems = [
  {name: 'home', caption: 'Home', roles: ['all']}
  {name: 'dashboard', caption: 'Dashboard', roles: ['tester', 'admin']}
  {name: 'chartEditor', caption: 'Chart Editor', roles: ['tester', 'admin']}
  {name: 'connectors', caption: 'Connectors', roles: ['tester', 'admin']}
  {name: 'adminPanel', caption: 'Admin Panel', roles: ['admin']}
]

Template.SidebarNavigation.helpers
#todo remove after adding invites
  samplesRoutes: ->
    navigationMenuItems.filter (item) -> true
#       Meteor.user()
