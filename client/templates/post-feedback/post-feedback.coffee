Template.PostFeedback.onRendered ->
  @feedbackInput = @$('.feedback-message-input')
  @closeModal = => @$('#postFeedbackModal').modal('hide')


Template.PostFeedback.events
  'click .post-feedback-button': (event, tmpl) ->
    feedbackMessage = tmpl.feedbackInput.val()
    Meteor.call 'postFeedback', feedbackMessage, App.handleError () ->
      tmpl.feedbackInput.val('')
      tmpl.closeModal()

  'shown.bs.modal #postFeedbackModal': (event, tmpl) ->
    tmpl.feedbackInput.focus()
