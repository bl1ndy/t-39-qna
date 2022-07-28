# frozen_string_literal: true

require 'rails_helper'

feature 'Any user can see the list of all questions', %(
  In order to find an already existing answer to my question
  As a guest or an authenticated user
  I'd like to be able to see list of all questions
) do
  given!(:questions) { create_list(:question, 5) }

  scenario 'Any user sees questions list' do
    visit questions_path

    questions.each { |question| expect(page).to have_content(question.title) }
  end
end
