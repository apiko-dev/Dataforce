Template.Spoiler.events
  'click .expand-button': (event, tmpl) ->
    setHeight = (height) -> tmpl.$('.spoiler-details').css({height: height})
    height = tmpl.$('.spoiler-details').css('height')

    detailsHeight = if tmpl.data?.detailsHeight then tmpl.data?.detailsHeight else ''

    setHeight if height is '1px' then detailsHeight else 0
    tmpl.$('.fa.expand-icon').toggleClass('fa-rotate-180')
    tmpl.$('.spoiler').toggleClass('expanded')
