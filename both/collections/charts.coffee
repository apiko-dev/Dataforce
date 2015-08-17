isOwner = (userId, doc) -> userId and doc.userId is userId

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