import Toast from "bootstrap/js/dist/toast"

$(document).on('turbolinks:load', function() {
  const liveToast = $('#liveToast')
  const toast = new Toast(liveToast)

  $('.vote-up-form')
    .on('ajax:success', (e) => {
      $('.rating').html(e.detail[0])
    })
    .on('ajax:error', (e) => {
      $('#liveToast .toast-body').html(e.detail[0][0])
      toast.show()
    })

  $('.vote-down-form')
    .on('ajax:success', (e) => {
      $('.rating').html(e.detail[0])
    })
    .on('ajax:error', (e) => {
      $('#liveToast .toast-body').html(e.detail[0][0])
      toast.show()
    })
})
