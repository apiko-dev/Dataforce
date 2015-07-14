DEBUG = yes

Meteor.methods
  getOpenTicketsNumber: ->
    getTicketsByStatus "open"

  getSolvedTicketsNumber: ->
    getTicketsByStatus "solved"

  getBacklogItemsNumber: ->
    getTicketsByStatus "solved", "<"

  getNewTicketsStatsForSevenDays: ->
    sevenDaysBefore = moment().subtract(7, "days")
    results = []

    for i in [0..6]
      newDate = sevenDaysBefore.add(1, "days").format("YYYY-MM-DD")

      if not DEBUG
        results.push Async.runSync (done) ->
          Zendesk().search.query "type:ticket created:#{newDate}", (err, req, res) ->
            if err
              console.error 'Zendesk error: ', err
              done err, -1
            else
              console.log res
              done {}, {date: newDate, data: res.length}
      else
        mockJson = JSON.parse HTTP.get("http://beta.json-generator.com/api/json/get/Ny3DfoaO").content
        fakeDayData =
          error: {}
          result:
            date: newDate
            data: _.random(1, 100)
        console.log fakeDayData
        results.push fakeDayData

    _.map results, (el) ->
      [el.result.date, el.result.data]

  getSatisfactionRatingForLastWeek: ->
    sevenDaysBefore = moment().subtract(7, "days")
    results = []

    for i in [0..6]
      newDate = sevenDaysBefore.add(1, "days").format("YYYY-MM-DD")
      mockJson = JSON.parse HTTP.get("http://beta.json-generator.com/api/json/get/Ny3DfoaO").content
      fakeDayData =
        error: {}
        result:
          date: newDate
          data: 0
      summaryRating = 0
      for ticket in mockJson
        summaryRating += getScoreBySatisfactionRatingName ticket.satisfaction_rating.score
      fakeDayData.result.data = summaryRating / mockJson.length
      console.log fakeDayData
      results.push fakeDayData

    (_.reduce(results, (memo, el) ->
      memo + el.result.data
    , 0) / 7).toFixed 2

getScoreBySatisfactionRatingName = (name) ->
  if name is "good"
    100
  else 0

getTicketsByStatus = (status, modifier) ->
  Async.runSync((done) ->
    Zendesk().search.query "type:ticket status#{modifier or ":"}#{status}", (err, req, res) ->
      if err
        console.error 'Zendesk error: ', err
        done err, 0
      else
        done err, res.length).result