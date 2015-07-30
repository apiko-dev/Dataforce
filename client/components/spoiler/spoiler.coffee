ANIMATION_SPEED = 500

animateAuto = (element, speed) ->
  elem = element.clone().css({"height": "auto", "width": "auto"}).appendTo("body")
  height = elem.css("height")
  elem.remove()

  element.animate {height: height}, speed


Template.Spoiler.onRendered ->
  @$('.content-wrapper *').not(".do-not-stop-propagate").click (e) -> e.stopPropagation()


Template.Spoiler.events
  'click .spoiler-head': (event, tmpl) ->
    spoilerDetails = tmpl.$('.spoiler-details')

    height = spoilerDetails.css('height')

    if height is '1px'
      animateAuto spoilerDetails, ANIMATION_SPEED
    else
      spoilerDetails.animate {height: 0}, ANIMATION_SPEED

    tmpl.$('.fa.expand-icon').toggleClass('fa-rotate-180')
    tmpl.$('.spoiler').toggleClass('expanded')
