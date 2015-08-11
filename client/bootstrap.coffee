Meteor.startup ->
  IntercomSettings.userInfo = (user, info) ->
    info.email = user.emails[0].address
    info.name = user.emails[0].address.split('@')[0]
#    info.tags =
#      type: 'tag.list'
#      tags: [id: user.roles[0]]
