isOwner = (userId, doc) -> userId and doc.userId is userId

Charts.allow
  insert: isOwner
  update: isOwner
  remove: isOwner

Charts.after.remove (userId, doc) ->
  Curves.remove chartId: doc._id