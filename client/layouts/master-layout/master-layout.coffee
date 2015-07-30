Template.MasterLayout.events
  'click .toggle-visibility-button': (event, tmpl) ->
    tmpl.$('#wrapper').toggleClass('toggled')
    $(window).resize() #necessary to resize highCharts chart