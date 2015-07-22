Template.gaChart.onCreated ->
  @chartType = new ReactiveVar "line"
  @series = new ReactiveVar ""
  @axisNames = new ReactiveVar ""
  @categories = new ReactiveVar ""

Template.gaChart.onRendered ->
  tpl = @
  Tracker.autorun ->
    series = tpl.series.get()
    categories = tpl.categories.get()
    chartType = tpl.chartType.get()
    axisNames = tpl.axisNames.get()

    # output debug info
    $("textarea").val("#{categories}\n#{JSON.stringify series}")

    initHighCharts = ->
      @.$("#chart").highcharts
        chart:
          type: chartType
        xAxis:
          categories: categories
          title:
            text: axisNames?.x or ""
        series: series

    initHighCharts()

Template.gaChart.events
  'click #chart-type-selector': (e, t) ->
    selectedChartType = t.$(e.target).val()
    Template.instance().chartType.set selectedChartType

  'click #getData': (e, t) ->
    metrics = []
    $("select.metrics-selector").each ->
      metrics.push $(@).val()
    mergeMetrics = $("#merge-metrics").prop("checked") or false
    profileId = $("#profile-selector").val()
    dimensions = $("#dimensions-selector").val()
    fromDate = $("#gaDatepicker input").eq(0).val()
    endDate = $("#gaDatepicker input").eq(1).val()

    chartQuery =
      profileId: profileId
      metrics: metrics.join ","
      mergeMetrics: mergeMetrics
      dimensions: dimensions
      from: fromDate
      to: endDate

    Meteor.call "GA.getData", chartQuery, (err, result) ->
      if not err
        gaAdapter = new App.DataAdapters.GoogleAnalytics chartQuery, result
        t.axisNames.set gaAdapter.getAxisNames()
        t.series.set gaAdapter.getSeries()
        t.categories.set gaAdapter.getCategories()
