isOwner = (userId, doc) -> userId and doc.userId is userId

Curves.allow
  insert: isOwner
  update: isOwner
  remove: isOwner