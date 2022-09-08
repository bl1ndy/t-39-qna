import Toast from "bootstrap/js/dist/toast"

$(document).on('turbolinks:load', function() {
  const liveToast = $('#liveToast')
  const toast = new Toast(liveToast)

  $('.vote-up-form')
    .on('ajax:success', (e) => {
      $('.rating').html(e.detail[0])
      $('.vote-up').addClass('hidden')
      $('.vote-up-cancel-form').removeClass('hidden')
      $('.vote-up-cancel').addClass('upvoted')
    })
    .on('ajax:error', (e) => {
      $('#liveToast .toast-body').html(e.detail[0][0])
      toast.show()
    })

  $('.vote-down-form')
    .on('ajax:success', (e) => {
      $('.rating').html(e.detail[0])
      $('.vote-down').addClass('hidden')
      $('.vote-down-cancel-form').removeClass('hidden')
      $('.vote-down-cancel').addClass('downvoted')
    })
    .on('ajax:error', (e) => {
      $('#liveToast .toast-body').html(e.detail[0][0])
      toast.show()
    })

  $('.vote-up-cancel-form')
    .on('ajax:success', (e) => {
      $('.rating').html(e.detail[0])
      $('.vote-up').removeClass('hidden')
      $('.vote-up-cancel-form').addClass('hidden')
    })
    .on('ajax:error', (e) => {
      $('#liveToast .toast-body').html('An error has occurred during vote cancelling')
      toast.show()
    })

  $('.vote-down-cancel-form')
    .on('ajax:success', (e) => {
      $('.rating').html(e.detail[0])
      $('.vote-down').removeClass('hidden')
      $('.vote-down-cancel-form').addClass('hidden')
    })
    .on('ajax:error', (e) => {
      $('#liveToast .toast-body').html('An error has occurred during vote cancelling')
      toast.show()
    })
})
