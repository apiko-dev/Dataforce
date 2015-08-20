@Charts = new Mongo.Collection('charts')

isOwner = (userId, doc) -> App.allowAccess(doc, userId)

Charts.allow
  insert: isOwner
  update: isOwner
  remove: isOwner

Charts.before.insert (userId, doc) ->
  doc.userId = userId
  doc.createdAt = new Date()

Charts.after.remove (userId, doc) ->
  if Meteor.isServer
    Curves.remove chartId: doc._id