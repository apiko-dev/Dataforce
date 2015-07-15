Template.SalesForceSample.events
  'click .test-button': (event, tmpl) ->
    Meteor.call 'testConnection', {
      accessToken: tmpl.data.accessToken
      instanceUrl: tmpl.data.instanceUrl
    }, (err, res) ->
      console.log 'test connection finished'
      console.log err, '\nresult ', res