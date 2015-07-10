Router.route '/', ->
  if @params.query.code
    Meteor.call "saveGAToken", @params.query.code
  @render 'main'