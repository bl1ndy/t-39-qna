import consumer from "./consumer"

$(document).on('turbolinks:load', function() {
  const answers = $('.answers')

  if (answers.length) {
    if (globalThis.answersSubscription) {
      globalThis.answersSubscription.unsubscribe()
    }

    const questionId = $('.question').parent().data('questionId')

    globalThis.answersSubscription = consumer.subscriptions.create({ channel: "AnswersChannel", question: questionId }, {
      connected() {
        this.perform('follow')
      },

      received(data) {
        const userId = $('#user-id').data('userId')

        if (data.author_id != userId) {
          answers.append(data.html)
        }
      }
    })
  }
})
