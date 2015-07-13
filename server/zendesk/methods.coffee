Meteor.methods
  getOpenTicketsNumber: ->
    Zendesk().search.query "type:ticket status:open", (err, req, res) ->
      if err
        console.error 'Zendesk error: ', err
        0
      else
        res.length