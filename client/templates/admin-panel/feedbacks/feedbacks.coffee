Template.Feedbacks.onCreated ->
  @subscribe 'feedbacks'

Template.Feedbacks.helpers
  feedbacks: -> Feedbacks.find {}, {sort: {postedAt: -1}}