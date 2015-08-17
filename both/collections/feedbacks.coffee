isTester = (userId) -> Roles.userIsInRole(userId, 'tester')

Feedbacks.allow
  insert: App.isAdmin
  update: App.isAdmin
  remove: App.isAdmin