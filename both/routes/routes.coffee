Router.map ->
  @route '/', ->
    if @params.query.code
      Meteor.call "saveGAToken", @params.query.code, (err, result) ->
        Router.go "/"
    @render 'googleAnalytics'


  @route '/sales-force-sample',
    name: 'salesForceSample',
    template: 'SalesForceSample'