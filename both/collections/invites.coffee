@Invites = new Mongo.Collection('invites')

Invites.allow
  insert: App.isAdmin
  update: App.isAdmin
  remove: App.isAdmin