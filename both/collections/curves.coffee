isOwner = (userId, doc) -> userId and doc.userId is userId

Curves.allow
  insert: isOwner
  update: isOwner
  remove: isOwner

Curves.before.insert (userId, doc) ->
  _.extend doc, {
    userId: userId
    createdAt: new Date()
    type: 'column'
    visible: true
  }

  #temporal; added for debugging; should be deleted in future
  doc.source = ConnectorNames.Salesforce