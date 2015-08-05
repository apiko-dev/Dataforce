#  global app's cope on client

_App =
#Used to process errors on client side in callbacks like `(err,res) ->`
  handleError: (onSuccess) ->
    return (err, res) ->
      if err
        _App.onError err
      else
        onSuccess(res) if onSuccess

#Displays error
  onError: (err) ->
    console.log 'Error handled\n', err
    alert err

#global app helpers
  helpers:
    matchSearchQuery: (targetStr) ->
      searchQuery = Session.get('searchQuery')
      searchQuery is '' or targetStr.toLowerCase().indexOf(searchQuery.toLowerCase()) > -1

  checkAdmin: -> Meteor.user().role is 'admin'


#register global helpers
for helperName of _App.helpers
  Template.registerHelper helperName, _App.helpers[helperName]

_.extend App, _App