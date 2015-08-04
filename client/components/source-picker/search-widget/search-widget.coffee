Template.SearchWidget.onRendered ->
  @searchInput = @$('.search-metric-input')
  @autorun =>
    query = Session.get('searchQuery')
    inputValue = @searchInput.val()

    #provide backward connection with session variable
    #to be able reset search using session
    if query isnt inputValue
      @searchInput.val(query)


Template.SearchWidget.events
  'keyup .search-metric-input': (event, tmpl) ->
    searchQuery = tmpl.searchInput.val()
    Session.set('searchQuery', searchQuery)
