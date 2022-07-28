# frozen_string_literal: true

require 'rails_helper'

feature 'User can delete his question', %(
  In order to avoid redundant or spam questions
  As an authenticated user
  I'd like to be able to delete my questions
) do
  given(:users) { create_list(:user, 2) }
  given(:question) { create(:question, user: users.first) }
  given(:other_question) { create(:question, user: users.last) }

  describe 'Authenticated user' do
    background { sign_in(users.first) }

    scenario 'delete his question' do
      visit question_path(question)
      click_link 'Delete Question'

      expect(page).to have_content('Your Question successfully deleted!')
      expect(page).not_to have_content(question.title)
    end

    scenario 'does not see delete button on someone else question' do
      visit question_path(other_question)

      expect(page).not_to have_content('Delete Question')
    end
  end

  scenario 'Guest does not see delete button on any question' do
    visit question_path(question)

    expect(page).not_to have_content('Delete Question')
  end
end
