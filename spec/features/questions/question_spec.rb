# frozen_string_literal: true

require 'rails_helper'

feature "User can see whole question and question's answers", %(
  In order to resolve my problem
  As a guest or an authenticated user
  I'd like to be able to see question and all question's answers
) do
  given(:question) { create(:question) }
  given!(:answers) { create_list(:answer, 5, question:, user: create(:user)) }

  scenario "Guest sees question and all question's answers" do
    visit question_path(question)

    expect(page).to have_content(question.title)
    expect(page).to have_content(question.body)
    answers.each { |answer| expect(page).to have_content(answer.body) }
  end
end
