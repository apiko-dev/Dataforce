Meteor.methods
  getProfilesList: (json) ->
    _.map json.result.items, (el) ->
      accountId: el.accountId
      profileId: el.id
      webPropertyId: el.webPropertyId
