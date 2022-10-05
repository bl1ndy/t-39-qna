import consumer from "./consumer"

$(document).on('turbolinks:load', function() {
  const questions = $('.questions')

  if (questions.length) {
    if (consumer.subscriptions.subscriptions.some(s => s.identifier.includes('QuestionsChannel'))) {
      return
    }

    consumer.subscriptions.create("QuestionsChannel", {
      connected() {
        this.perform('follow')
      },

      received(data) {
        questions.append(data)
      }
    })
  }
})
