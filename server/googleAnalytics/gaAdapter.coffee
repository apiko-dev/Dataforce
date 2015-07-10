Meteor.methods
  getProfilesList: (json) ->
    _.map json.result.items, (el) ->
      console.log el
      accountId: el.accountId
      profileId: el.id
      webPropertyId: el.webPropertyId
      name: if el.websiteUrl.length > 3 then el.websiteUrl else el.webPropertyId
