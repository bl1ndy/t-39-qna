# frozen_string_literal: true

require 'rails_helper'

feature 'User can create an answer on the question page', %(
  In order to answer somebody's question
  As an authenticated user
  I'd like to be able to create an answer
), js: true do
  given(:user) { create(:user) }
  given(:question) { create(:question) }

  describe 'Authenticated user' do
    background do
      sign_in(user)
      visit question_path(question)
    end

    scenario 'creates an answer' do
      fill_in 'Text', with: 'Test Answer text'
      click_button 'Post Your Answer'

      expect(page).to have_content('Test Answer text')
    end

    scenario 'creates an answer with errors' do
      click_button 'Post Your Answer'

      expect(page).to have_content("Body can't be blank")
    end
  end

  describe 'Guest' do
    scenario 'does not see answer form' do
      visit question_path(question)

      expect(page).not_to have_content('Post Your Answer')
    end

    scenario 'redirects to sign_in page' do
      visit new_question_path

      expect(page).to have_current_path(new_user_session_path)
    end
  end
end
