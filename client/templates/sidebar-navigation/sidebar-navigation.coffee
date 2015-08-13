navigationMenuItems = [
  {name: 'home', caption: 'Home', roles: false}
  {name: 'dashboard', caption: 'Dashboard', roles: ['tester', 'admin']}
  {name: 'chartEditor', caption: 'Chart Editor', roles: ['tester', 'admin']}
  {name: 'connectors', caption: 'Connectors', roles: ['tester', 'admin']}
  {name: 'adminPanel', caption: 'Admin Panel', roles: ['admin']}
]

Template.SidebarNavigation.onRendered ->
  @$('#side-menu').metisMenu();

Template.SidebarNavigation.helpers
  samplesRoutes: ->
    navigationMenuItems.filter (item) -> !item.roles or Roles.userIsInRole Meteor.userId(), item.roles