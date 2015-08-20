@Feedbacks = new Mongo.Collection('feedbacks')

Feedbacks.allow
  insert: App.isAdmin
  update: App.isAdmin
  remove: App.isAdmin