DEBUG = yes

Meteor.methods

  "Zendesk.getJsonData": (chartQuery) ->
    check chartQuery, {
      query: String
    }
    JSON.parse HTTP.get("http://beta.json-generator.com/api/json/get/Ny3DfoaO").content

  getOpenTicketsNumber: ->
    getTicketsByStatus "open"

  getSolvedTicketsNumber: ->
    getTicketsByStatus "solved"

  getBacklogItemsNumber: ->
    getTicketsByStatus "solved", "<"

  getNewTicketsStatsForSevenDays: ->
    sevenDaysBefore = moment().subtract(7, "days")
    results = []

    _.times 7, ->
      newDate = sevenDaysBefore.add(1, "days").format("YYYY-MM-DD")

      if not DEBUG
        results.push Async.runSync (done) ->
          Zendesk().search.query "type:ticket created:#{newDate}", (err, req, res) ->
            if err
              console.error 'Zendesk error: ', err
              done err, -1
            else
              done {}, {date: newDate, data: res.length}
      else
        mockJson = JSON.parse HTTP.get("http://beta.json-generator.com/api/json/get/Ny3DfoaO").content
        fakeDayData =
          error: {}
          result:
            date: newDate
            data: _.random(1, 5)
        results.push fakeDayData

    _.map results, (el) ->
      [el.result.date, el.result.data]

  getSatisfactionRatingForLastWeek: (summaryRating) ->
    check summaryRating, Boolean
    sevenDaysBefore = moment().subtract(7, "days")
    results = []
    totalTicketsRating = 0
    totalTicketsNumber = 0

    _.times 7, ->
      newDate = sevenDaysBefore.add(1, "days").format("YYYY-MM-DD")
      mockJson = JSON.parse HTTP.get("http://beta.json-generator.com/api/json/get/Ny3DfoaO").content

      fakeDayData =
        date: newDate
        data: 0

      summaryDayRating = 0
      for ticket in mockJson
        score = getScoreBySatisfactionRatingName ticket.satisfaction_rating.score
        if summaryRating
          totalTicketsRating += score
          totalTicketsNumber++
        else summaryDayRating += score
      fakeDayData.data = if DEBUG then _.random(1, 12) + Math.random() else summaryDayRating / mockJson.length

      results.push fakeDayData

    if summaryRating
      (_.reduce(results, (memo, el) ->
        return memo + el.data
      , 0) / 7).toFixed 2
    else
      _.map results, (el) ->
        [el.date, el.data]

  getSolvedTicketsForLastWeek: ->
    sevenDaysBefore = moment().subtract(7, "days")
    results = []
    _.times 7, ->
      newDate = sevenDaysBefore.add(1, "days").format("YYYY-MM-DD")
      apiCallResult = Async.runSync (done) ->
        Zendesk().search.query "type:ticket status:solved created:#{newDate}", (err, req, res) ->
          if err
            console.error 'Zendesk error: ', err
            done err, 0
          else
            done err, {
              date: newDate
              data: if DEBUG then _.random(1, 5) else res.length
            }
      results.push apiCallResult.result

    results = _.map results, (el) ->
      [el.date, el.data]
    results

getScoreBySatisfactionRatingName = (name) ->
  if name is "good"
    100
  else 0

getTicketsByStatus = (status, modifier) ->
  Async.runSync (done) ->
    Zendesk().search.query "type:ticket status#{modifier or ":"}#{status}", (err, req, res) ->
      if err
        console.error 'Zendesk error: ', err
        done err, []
      else
        done err, res