Template.Spoiler.onRendered ->
  @$('.content-wrapper *').not('[role="spoiler-collapse"]').click (e) -> e.stopPropagation()

  spoilerDetails = @$('.spoiler-details')

  #opened spoilers support
  @autorun =>
    data = Template.currentData()
    if data?.opened
      spoilerDetails.addClass('in')
    else
      spoilerDetails.removeClass('in')


Template.Spoiler.events
  'click .spoiler-head': (event, tmpl) -> tmpl.$('.spoiler-details').collapse('toggle')

