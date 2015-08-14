Template.MasterLayout.onRendered ->
  $(window).bind 'load resize', ->
    width = if @window.innerWidth > 0 then @window.innerWidth else @screen.width
    if width < 768
      $('div.navbar-collapse').addClass 'collapse'
# 2-row-menu
    else
      $('div.navbar-collapse').removeClass 'collapse'