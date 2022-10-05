import consumer from "./consumer"

$(document).on('turbolinks:load', function() {
  const comments = $('.comments')

  if (comments.length) {
    if (consumer.subscriptions.subscriptions.some(s => s.identifier.includes('CommentsChannel'))) {
      return
    }

    consumer.subscriptions.create({ channel: 'CommentsChannel' }, {
      connected() {
        this.perform('follow')
      },

      received(data) {
        const userId = $('#user-id').data('userId')

        if (data.author_id != userId) {
          $(`#${data.commentable_selector}`).find('.comments').append(data.html)
        }
      }
    })
  }
})
