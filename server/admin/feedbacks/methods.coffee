Meteor.methods
  postFeedback: (feedbackMessage) ->
    check feedbackMessage, String
    if @userId
      currentUser = Meteor.users.findOne {_id: @userId}
      authorEmail = currentUser.emails[0].address
      Feedbacks.insert {
        message: feedbackMessage
        postedAt: new Date()
        author:
          email: authorEmail
          id: @userId
      }