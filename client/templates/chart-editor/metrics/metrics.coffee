Template.Metrics.onCreated ->
  @searchPhrase = new ReactiveVar('')


Template.Metrics.events
  'keyup .metrics-search-input': (event, tmpl) ->
    text = tmpl.$('.metrics-search-input').val()
    tmpl.searchPhrase.set text

Template.Metrics.helpers
#search stuff
  isMatchSearch: (target) ->
    searchPhrase = Template.instance().searchPhrase.get().toLowerCase()
    if searchPhrase.length > 0 then target.toLowerCase().indexOf(searchPhrase) > -1 else true


#todo: this stuff should be moved away from source code
  metricMocks: -> [
    {
      connectorName: "SF"
      metrics: [
        {name: 'Users'}
        {name: 'Accounts'}
        {name: 'Campaigns'}
        {name: 'Opportunities'}
      ]
    }
    {
      connectorName: "GA"
      metrics: [
        {name: "ga:users"}
        {name: "ga:newUsers"}
        {name: "ga:percentNewSessions"}
        {name: "ga:sessionsPerUser"}
        {name: "ga:visitors"}
        {name: "ga:newVisits"}
        {name: "ga:percentNewVisits"}
        {name: "ga:sessions"}
        {name: "ga:bounces"}
        {name: "ga:bounceRate"}
        {name: "ga:sessionDuration"}
        {name: "ga:avgSessionDuration"}
        {name: "ga:hits"}
        {name: "ga:visits"}
        {name: "ga:entranceBounceRate"}
        {name: "ga:visitBounceRate"}
        {name: "ga:timeOnSite"}
        {name: "ga:avgTimeOnSite"}
        {name: "ga:organicSearches"}
        {name: "ga:impressions"}
        {name: "ga:adClicks"}
        {name: "ga:adCost"}
        {name: "ga:CPM"}
        {name: "ga:CPC"}
        {name: "ga:CTR"}
        {name: "ga:costPerTransaction"}
        {name: "ga:costPerGoalConversion"}
        {name: "ga:costPerConversion"}
        {name: "ga:RPC"}
        {name: "ga:ROAS"}
        {name: "ga:ROI"}
        {name: "ga:margin"}
        {name: "ga:goalXXStarts"}
        {name: "ga:goalStartsAll"}
        {name: "ga:goalXXCompletions"}
        {name: "ga:goalCompletionsAll"}
        {name: "ga:goalXXValue"}
        {name: "ga:goalValueAll"}
        {name: "ga:goalValuePerSession"}
        {name: "ga:goalXXConversionRate"}
        {name: "ga:goalConversionRateAll"}
        {name: "ga:goalXXAbandons"}
        {name: "ga:goalAbandonsAll"}
        {name: "ga:goalXXAbandonRate"}
        {name: "ga:goalAbandonRateAll"}
        {name: "ga:goalValuePerVisit"}
        {name: "ga:socialActivities"}
        {name: "ga:pageValue"}
        {name: "ga:entrances"}
        {name: "ga:entranceRate"}
        {name: "ga:pageviews"}
        {name: "ga:pageviewsPerSession"}
        {name: "ga:uniquePageviews"}
        {name: "ga:timeOnPage"}
        {name: "ga:avgTimeOnPage"}
        {name: "ga:exits"}
        {name: "ga:exitRate"}
        {name: "ga:pageviewsPerVisit"}
        {name: "ga:contentGroupUniqueViewsXX"}
        {name: "ga:searchResultViews"}
        {name: "ga:searchUniques"}
        {name: "ga:avgSearchResultViews"}
        {name: "ga:searchSessions"}
        {name: "ga:percentSessionsWithSearch"}
        {name: "ga:searchDepth"}
        {name: "ga:avgSearchDepth"}
        {name: "ga:searchRefinements"}
        {name: "ga:percentSearchRefinements"}
        {name: "ga:searchDuration"}
        {name: "ga:avgSearchDuration"}
        {name: "ga:searchExits"}
        {name: "ga:searchExitRate"}
        {name: "ga:searchGoalXXConversionRate"}
        {name: "ga:searchGoalConversionRateAll"}
        {name: "ga:goalValueAllPerSearch"}
        {name: "ga:searchVisits"}
        {name: "ga:percentVisitsWithSearch"}
        {name: "ga:pageLoadTime"}
        {name: "ga:pageLoadSample"}
        {name: "ga:avgPageLoadTime"}
        {name: "ga:domainLookupTime"}
        {name: "ga:avgDomainLookupTime"}
        {name: "ga:pageDownloadTime"}
        {name: "ga:avgPageDownloadTime"}
        {name: "ga:redirectionTime"}
        {name: "ga:avgRedirectionTime"}
        {name: "ga:serverConnectionTime"}
        {name: "ga:avgServerConnectionTime"}
        {name: "ga:serverResponseTime"}
        {name: "ga:avgServerResponseTime"}
        {name: "ga:speedMetricsSample"}
        {name: "ga:domInteractiveTime"}
        {name: "ga:avgDomInteractiveTime"}
        {name: "ga:domContentLoadedTime"}
        {name: "ga:avgDomContentLoadedTime"}
        {name: "ga:domLatencyMetricsSample"}
        {name: "ga:screenviews"}
        {name: "ga:uniqueScreenviews"}
        {name: "ga:screenviewsPerSession"}
        {name: "ga:timeOnScreen"}
        {name: "ga:avgScreenviewDuration"}
        {name: "ga:appviews"}
        {name: "ga:uniqueAppviews"}
        {name: "ga:appviewsPerVisit"}
        {name: "ga:totalEvents"}
        {name: "ga:uniqueEvents"}
        {name: "ga:eventValue"}
        {name: "ga:avgEventValue"}
        {name: "ga:sessionsWithEvent"}
        {name: "ga:eventsPerSessionWithEvent"}
        {name: "ga:visitsWithEvent"}
        {name: "ga:eventsPerVisitWithEvent"}
        {name: "ga:transactions"}
        {name: "ga:transactionsPerSession"}
        {name: "ga:transactionRevenue"}
        {name: "ga:revenuePerTransaction"}
        {name: "ga:transactionRevenuePerSession"}
        {name: "ga:transactionShipping"}
        {name: "ga:transactionTax"}
        {name: "ga:totalValue"}
        {name: "ga:itemQuantity"}
        {name: "ga:uniquePurchases"}
        {name: "ga:revenuePerItem"}
        {name: "ga:itemRevenue"}
        {name: "ga:itemsPerPurchase"}
        {name: "ga:localTransactionRevenue"}
        {name: "ga:localTransactionShipping"}
        {name: "ga:localTransactionTax"}
        {name: "ga:localItemRevenue"}
        {name: "ga:buyToDetailRate"}
        {name: "ga:cartToDetailRate"}
        {name: "ga:internalPromotionCTR"}
        {name: "ga:internalPromotionClicks"}
        {name: "ga:internalPromotionViews"}
        {name: "ga:localProductRefundAmount"}
        {name: "ga:localRefundAmount"}
        {name: "ga:productAddsToCart"}
        {name: "ga:productCheckouts"}
        {name: "ga:productDetailViews"}
        {name: "ga:productListCTR"}
        {name: "ga:productListClicks"}
        {name: "ga:productListViews"}
        {name: "ga:productRefundAmount"}
        {name: "ga:productRefunds"}
        {name: "ga:productRemovesFromCart"}
        {name: "ga:productRevenuePerPurchase"}
        {name: "ga:quantityAddedToCart"}
        {name: "ga:quantityCheckedOut"}
        {name: "ga:quantityRefunded"}
        {name: "ga:quantityRemovedFromCart"}
        {name: "ga:refundAmount"}
        {name: "ga:revenuePerUser"}
        {name: "ga:totalRefunds"}
        {name: "ga:transactionsPerUser"}
        {name: "ga:transactionsPerVisit"}
        {name: "ga:transactionRevenuePerVisit"}
        {name: "ga:socialInteractions"}
        {name: "ga:uniqueSocialInteractions"}
        {name: "ga:socialInteractionsPerSession"}
        {name: "ga:socialInteractionsPerVisit"}
        {name: "ga:userTimingValue"}
        {name: "ga:userTimingSample"}
        {name: "ga:avgUserTimingValue"}
        {name: "ga:exceptions"}
        {name: "ga:exceptionsPerScreenview"}
        {name: "ga:fatalExceptions"}
        {name: "ga:fatalExceptionsPerScreenview"}
        {name: "ga:metricXX"}
        {name: "ga:dcmFloodlightQuantity"}
        {name: "ga:dcmFloodlightRevenue"}
        {name: "ga:dcmCPC"}
        {name: "ga:dcmCTR"}
        {name: "ga:dcmClicks"}
        {name: "ga:dcmCost"}
        {name: "ga:dcmImpressions"}
        {name: "ga:dcmROAS"}
        {name: "ga:dcmRPC"}
        {name: "ga:dcmMargin"}
        {name: "ga:dcmROI"}
        {name: "ga:adsenseRevenue"}
        {name: "ga:adsenseAdUnitsViewed"}
        {name: "ga:adsenseAdsViewed"}
        {name: "ga:adsenseAdsClicks"}
        {name: "ga:adsensePageImpressions"}
        {name: "ga:adsenseCTR"}
        {name: "ga:adsenseECPM"}
        {name: "ga:adsenseExits"}
        {name: "ga:adsenseViewableImpressionPercent"}
        {name: "ga:adsenseCoverage"}
        {name: "ga:correlationScore"}
        {name: "ga:queryProductQuantity"}
        {name: "ga:relatedProductQuantity"}
      ]
    }
  ]