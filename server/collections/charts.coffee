isOwner = (userId, doc) -> doc.userId is userId

Charts.allow
  insert: isOwner
  update: isOwner
  remove: isOwner