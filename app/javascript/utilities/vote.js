import Toast from "bootstrap/js/dist/toast"

$(document).on('turbolinks:load', function() {
  const controls = $('.vote-control')

  if (controls.length) {
    const liveToast = $('#liveToast')
    const toast = new Toast(liveToast)

    controls.each(function () {
      $(this).find('.vote-up-form')
        .on('ajax:success', (e) => {
          $(this).find('.rating').html(e.detail[0])
          $(this).find('.vote-up').addClass('hidden')
          $(this).find('.vote-up-cancel-form').removeClass('hidden')
          $(this).find('.vote-up-cancel').addClass('upvoted')
        })
        .on('ajax:error', (e) => {
          $('#liveToast .toast-body').html(e.detail[0][0])
          toast.show()
        })

      $(this).find('.vote-down-form')
        .on('ajax:success', (e) => {
          $(this).find('.rating').html(e.detail[0])
          $(this).find('.vote-down').addClass('hidden')
          $(this).find('.vote-down-cancel-form').removeClass('hidden')
          $(this).find('.vote-down-cancel').addClass('downvoted')
        })
        .on('ajax:error', (e) => {
          $('#liveToast .toast-body').html(e.detail[0][0])
          toast.show()
        })

      $(this).find('.vote-up-cancel-form')
        .on('ajax:success', (e) => {
          $(this).find('.rating').html(e.detail[0])
          $(this).find('.vote-up').removeClass('hidden')
          $(this).find('.vote-up-cancel-form').addClass('hidden')
        })
        .on('ajax:error', (e) => {
          $('#liveToast .toast-body').html('An error has occurred during vote cancelling')
          toast.show()
        })

      $(this).find('.vote-down-cancel-form')
        .on('ajax:success', (e) => {
          $(this).find('.rating').html(e.detail[0])
          $(this).find('.vote-down').removeClass('hidden')
          $(this).find('.vote-down-cancel-form').addClass('hidden')
        })
        .on('ajax:error', (e) => {
          $('#liveToast .toast-body').html('An error has occurred during vote cancelling')
          toast.show()
        })
    })
  }
})
