$(document).on('turbolinks:load', function() {
  $('.answers').on('click', '.edit-answer-link', function(e) {
    e.preventDefault()
    $(this).hide()
    let answerId = $(this).data('answerId')
    $('div#edit-answer-' + answerId).removeClass('hidden')
  })
})
