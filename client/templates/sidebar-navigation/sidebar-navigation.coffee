navigationMenuItems = [
  {name: 'home', caption: 'Home', icon: 'home', roles: false}
  {name: 'dashboard', caption: 'Dashboard', icon: 'dashboard', roles: ['tester', 'admin']}
  {name: 'chartEditor', caption: 'Chart Editor', icon: 'bar-chart', roles: ['tester', 'admin']}
  {name: 'connectors', caption: 'Connectors', icon: 'link', roles: ['tester', 'admin']}
  {name: 'adminPanel', caption: 'Admin Panel', icon: 'hand-spock-o', roles: ['admin']}
]

Template.SidebarNavigation.onRendered ->
  @$('#side-menu').metisMenu();

Template.SidebarNavigation.helpers
  samplesRoutes: ->
    navigationMenuItems.filter (item) -> !item.roles or Roles.userIsInRole Meteor.userId(), item.roles