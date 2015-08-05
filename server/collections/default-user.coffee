Meteor.startup ->
  if Meteor.users.find().count() is 0
    defaultUserDoc = JSON.parse Assets.getText('default-user.json')
    Meteor.users.insert defaultUserDoc
    console.log 'No users were found, so default user was created'