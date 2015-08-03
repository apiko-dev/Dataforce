Template.MetricsItem.onRendered ->
  @$(':radio').radiocheck()


Template.MetricsItem.onDestroyed ->
  @$(':radio').radiocheck('destroy')