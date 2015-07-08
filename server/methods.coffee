CLIENT_ID = "731739422252-19e4u0b1demcma8i837cpcn2p53tiu3s.apps.googleusercontent.com"
CLIENT_SECRET = "7isvZNmXhxSFaMrUko8UADqA"
REDIRECT_URL = "http://localhost:3000/"
SCOPES = ["https://www.googleapis.com/auth/analytics.readonly"]

googleapis = Meteor.npmRequire "googleapis"
googleAnalytics = googleapis.analytics "v3"
OAuth2 = googleapis.auth.OAuth2
oauth2Client = new OAuth2

Meteor.methods
  getGAaccounts: (userId) ->
    gaCredentials = getUserCredentials userId
    console.log gaCredentials
    oauth2Client.setCredentials gaCredentials

#  getViewData: (viewID) ->
#    googleAnalytics.data.ga.get {
#      auth: oauth2Client
#      'ids': 'ga:97749326'
#      'start-date': '2014-01-01'
#      'end-date': '2015-05-01'
#      'metrics': 'ga:visits'
#    }, (err, result) ->
#      console.log err
#      console.log result


getUserCredentials = (userId) ->
  userObj = Meteor.users.findOne _id: userId
  credentials =
    access_token: userObj?.services?.google?.accessToken
    token_type: "Bearer"
    refresh_token: userObj?.services?.google?.refreshToken
  credentials

