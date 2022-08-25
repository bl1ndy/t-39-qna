$(document).on('turbolinks:load', function() {
  getAllGists()

  $('.edit-question-form').on('submit', getUpdatedQuestionGists)

  $('*[id*=edit-answer-]').on('submit', getUpdatedAnswerGists)

  $('.new-answer').on('submit', getNewAnswerGists)
})

const getAllGists = function() {
  const gistLinks = $('.gist-link')

  getContent(gistLinks)
}

const getUpdatedQuestionGists = function() {
  setTimeout(function() {
    const gistLinks = $('.question .gist-link')

    getContent(gistLinks)
  }, 500)
}

const getNewAnswerGists = function() {
  setTimeout(function() {
    const gistLinks = $(`.answers .card:last-child .gist-link`)

    getContent(gistLinks)
  }, 500)
}

const getUpdatedAnswerGists = function(e) {
  setTimeout(function() {
    const answerId = $(e.target).data('answerId')
    const gistLinks = $(`#answer-${answerId} .gist-link`)

    getContent(gistLinks)
  }, 500)
}

const getContent = function(gistLinks) {
  gistLinks.each(function() {
    const linkId = $(this).data('linkId')
    const gistId = $(this).attr('href').split('/').pop()

    $.get('https://api.github.com/gists/' + gistId)
      .done((data) => { formatContent(data.files, linkId) })
      .fail(function() { formatContent(false, linkId) })
  })
}

const formatContent = function(files, linkId) {
  const gistContent = $(`.gist-link[data-link-id="${linkId}"] ~ .gist-content`)
  gistContent.html('')
  gistContent.removeClass('hidden')

  if (files) {
    $.each(files, (key, value) => {
      gistContent.append(key + '\n').append(value.content + '\n')
    })
  } else {
    gistContent.append('Gist not found')
  }
}
