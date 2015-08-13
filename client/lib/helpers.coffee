Template.registerHelper 'formatDate', (rawDate) ->
  moment(rawDate, 'ddd MMM DD YYYY HH:mm:ss').fromNow()