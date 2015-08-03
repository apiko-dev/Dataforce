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


_.extend App, _App