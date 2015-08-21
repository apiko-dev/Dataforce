Template.ChartEditor.onCreated ->
  @updateChartName = =>
    chartName = @$('.chart-name').val()
    if chartName isnt @data.name
      Charts.update {_id: @data._id}, $set: {name: chartName}


Template.ChartEditor.onRendered ->
#  apply sticky position to chart preview
  scrollThreshold = 56
  element = @$('.preview-column')
  stickyPreviewClass = 'sticky-preview'
  widthSource = @$('.preview-column-wrapper')

  @scrollHandler = (e) ->
    scrollTop = e.target.scrollTop

    isThreshold = scrollTop >= scrollThreshold
    isSticky = element.hasClass stickyPreviewClass

    if isThreshold and not isSticky
      element.addClass stickyPreviewClass
      element.css('width', widthSource.width())
    else if not isThreshold and isSticky
      element.removeClass stickyPreviewClass
      element.css('width', 'auto')

  $('.page-content').on 'scroll', @scrollHandler


Template.ChartEditor.onDestroyed ->
  $('.page-content').off 'scroll', @scrollHandler


Template.ChartEditor.events
  'keyup .chart-name': (event, tmpl) ->
    if event.which is 13 #pressed enter
      tmpl.updateChartName()

  'blur .chart-name': (event, tmpl) ->
    tmpl.updateChartName()
