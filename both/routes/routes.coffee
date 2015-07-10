Router.map ->
  @route '/', ->
    @render 'main'

  @route '/sales-force-sample',
    name: 'salesForceSample',
    template: 'SalesForceSample'