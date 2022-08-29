import Toast from "bootstrap/js/dist/toast"

$(document).on('turbolinks:load', function() {
  const voteButtons = $('.vote')
  const liveToast = $('#liveToast')

  voteButtons.each(function() {
    $(this).on('click', () => {
      const toast = new Toast(liveToast)

      toast.show()
    })
  })
})
