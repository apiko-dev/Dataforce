isOwner = (userId, doc) ->

  userId and doc.userId is userId

Charts.allow
  insert: isOwner
  update: isOwner
  remove: isOwner