Router.route '/', ->
  if @params.query.code
    Meteor.call "saveGAToken", @params.query.code, (err, result) ->
      Router.go "/"
  @render 'main'