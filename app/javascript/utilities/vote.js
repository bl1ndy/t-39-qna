import Toast from "bootstrap/js/dist/toast"

$(document).on('turbolinks:load', function() {
  const voteUp = $('.vote-up')
  const voteDown = $('.vote-down')
  const liveToast = $('#liveToast')
  const toast = new Toast(liveToast)

  voteUp.on('click', () => {
    $('#liveToast .toast-body').html('Upvoted!')
    toast.show()
  })

  voteDown.on('click', () => {
    $('#liveToast .toast-body').html('Downvoted :(')
    toast.show()
  })
})
