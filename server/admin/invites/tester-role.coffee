Meteor.startup ->
  unless Meteor.roles.findOne({name: 'tester'})
    Roles.createRole('tester')