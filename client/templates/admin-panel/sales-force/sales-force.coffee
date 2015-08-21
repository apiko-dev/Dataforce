Template.SalesforceAdminTab.events
  'click .update-descriptions-button': (event, tmpl) ->
    Meteor.call 'sfUpdateTablesDescriptions', App.handleError (res) ->
      alert('Success')