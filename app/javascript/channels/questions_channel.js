import consumer from "./consumer"

let connected = false

$(document).on('turbolinks:load', function() {
  const questions = $('.questions')

  if (questions.length && !connected) {
    consumer.subscriptions.create("QuestionsChannel", {
      connected() {
        this.perform('follow')
        connected = true
      },

      received(data) {
        questions.append(data)
      }
    })
  }
})
