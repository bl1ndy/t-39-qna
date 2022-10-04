import consumer from "./consumer"

$(document).on('turbolinks:load', function() {
  const answers = $('.answers')

  if (answers.length) {
    consumer.subscriptions.create({ channel: "AnswersChannel", question: gon.question_id }, {
      connected() {
        this.perform('follow')
      },

      received(data) {
        if (data.author_id != gon.user_id) {
          answers.append(data.html)
        }
      }
    })
  }
})
