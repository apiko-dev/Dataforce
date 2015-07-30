Template.Spoiler.onRendered ->
  @$('.content-wrapper *').not('[role="spoiler-collapse"]').click (e) -> e.stopPropagation()


Template.Spoiler.events
  'click .spoiler-head': (event, tmpl) -> tmpl.$('.spoiler-details').collapse('toggle')

