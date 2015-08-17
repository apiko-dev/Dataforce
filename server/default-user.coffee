addAdminUser = ->
  defaultUserDoc = JSON.parse Assets.getText('default-user.json')
  Meteor.users.insert defaultUserDoc
  Roles.addUsersToRoles defaultUserDoc._id, ['admin']
  console.log 'No users were found, so default user was created'


Meteor.startup ->
  if Meteor.users.find().count() is 0
    addAdminUser()
