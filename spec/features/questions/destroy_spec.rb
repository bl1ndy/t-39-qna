# frozen_string_literal: true

require 'rails_helper'

feature 'User can delete his question', %(
  In order to avoid redundant or spam questions
  As an authenticated user
  I'd like to be able to delete my questions
) do
  given(:user) { create(:user) }
  given(:another_user) { create(:user) }
  given(:question) { create(:question, user:) }
  given(:another_question) { create(:question, user: another_user) }

  describe 'Authenticated user' do
    background { sign_in(user) }

    scenario 'delete his question' do
      visit question_path(question)

      within '.question' do
        click_link 'Delete'
      end

      expect(page).to have_content('Your Question successfully deleted!')
      expect(page).not_to have_content(question.title)
    end

    scenario 'does not see delete button on someone else question' do
      visit question_path(another_question)

      within '.question' do
        expect(page).not_to have_link('Delete')
      end
    end
  end

  scenario 'Guest does not see delete button on any question' do
    visit question_path(question)

    within '.question' do
      expect(page).not_to have_link('Delete')
    end
  end
end
