Template.MasterLayout.events
  'click .toggle-visibility-button': (event, tmpl) ->
    tmpl.$('#wrapper').toggleClass('toggled')
    recalculateChartsSize()

recalculateChartsSize = ->
  sidebarCollapsingTime = 500
  Meteor.setTimeout ->
    $(window).resize() #necessary to resize highCharts chart
  , sidebarCollapsingTime