Template.Spoiler.onRendered ->
  @$('.content-wrapper *').not('[role="spoiler-collapse"]').click (e) -> e.stopPropagation()

  spoilerDetails = @$('.spoiler-details')

  #opened spoilers support
  @autorun =>
    data = Template.currentData()
    if data?.opened
      spoilerDetails.addClass('in')
      @$('.expand-icon').addClass('fa-rotate-180')
    else
      spoilerDetails.removeClass('in')
      @$('.expand-icon').removeClass('fa-rotate-180')


Template.Spoiler.events
  'click .spoiler-head': (event, tmpl) ->
    tmpl.$('.spoiler-details').collapse('toggle')
    tmpl.$('.expand-icon').toggleClass('fa-rotate-180')

