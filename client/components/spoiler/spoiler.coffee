Template.Spoiler.onRendered ->
  @$('.content-wrapper *').not(".do-not-stop-propagate").click (e) -> e.stopPropagation()


Template.Spoiler.events
  'click .spoiler-head': (event, tmpl) -> tmpl.$('.spoiler-details').collapse('toggle')

