# frozen_string_literal: true

require 'rails_helper'

feature 'User can delete his answer', %(
  In order to avoid redundant answers
  As an authenticated user
  I'd like to be able to delete my answers
) do
  given(:user1) { create(:user) }
  given(:user2) { create(:user) }
  given(:question) { create(:question, user: user2) }
  given!(:answer1) { create(:answer, question:, user: user1) }
  given!(:answer2) { create(:answer, question:, user: user2) }

  describe 'Authenticated user' do
    background do
      sign_in(user1)
      visit question_path(question)
    end

    scenario 'delete his answer' do
      click_link 'Delete Answer'

      expect(page).to have_content('Your Answer successfully deleted!')
      expect(page).to have_no_content(answer1.body)
    end

    scenario 'does not see delete button on someone else answer' do
      expect(page).to have_no_link('Delete Answer', href: answer_path(answer2))
    end
  end

  describe 'Guest' do
    scenario 'does not see delete button on any answer' do
      visit question_path(question)

      expect(page).to have_no_link('Delete Answer')
    end
  end
end
