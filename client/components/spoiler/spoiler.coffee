Template.Spoiler.onRendered ->
  spoilerDetails = @$('.spoiler-details')

  #opened spoilers support
  @autorun =>
    data = Template.currentData()
    if data?.opened
      spoilerDetails.collapse('show')
      @$('.expand-icon').addClass('fa-rotate-180')
    else
      spoilerDetails.collapse('hide')
      @$('.expand-icon').removeClass('fa-rotate-180')


Template.Spoiler.events
  'click .expand-button, click [role="spoiler-collapse"]': (event, tmpl) ->
    tmpl.$('.spoiler-details').collapse('toggle')
    tmpl.$('.expand-icon').toggleClass('fa-rotate-180')

