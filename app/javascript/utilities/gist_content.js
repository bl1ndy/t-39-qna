$(document).on('turbolinks:load', function() {
  getAllGists()

  $('.edit-question-form').on('submit', getUpdatedQuestionGists)

  $('*[id*=edit-answer-]').on('submit', getUpdatedAnswerGists)
})

const getAllGists = function() {
  const gistLinks = $('.gist-link')

  gistLinks.each(function() {
    const linkId = $(this).data('linkId')

    getContent(this, linkId)
  })
}

const getUpdatedQuestionGists = function() {
  setTimeout(function() {
    const gistLinks = $('.question .gist-link')

    gistLinks.each(function() {
      const linkId = $(this).data('linkId')

      getContent(this, linkId)
    })
  }, 500)
}

const getUpdatedAnswerGists = function(e) {
  setTimeout(function() {
    const answerId = $(e.target).data('answerId')
    const gistLinks = $(`#answer-${answerId} .gist-link`)

    gistLinks.each(function() {
      const linkId = $(this).data('linkId')

      getContent(this, linkId)
    })
  }, 500)
}

const getContent = function(gist, linkId) {
  const gistId = $(gist).attr('href').split('/').pop()

  $.get('https://api.github.com/gists/' + gistId).done((data) => { formatContent(data.files, linkId) } )
}

const formatContent = function(files, linkId) {
  const gistContent = $(`.gist-link[data-link-id="${linkId}"] ~ .gist-content`)

  $.each(files, (key, value) => {
    gistContent.removeClass('hidden')
    gistContent.html('')
    gistContent.append(key).append(value.content)
  })
}
