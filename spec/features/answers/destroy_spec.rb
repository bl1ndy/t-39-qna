# frozen_string_literal: true

require 'rails_helper'

feature 'User can delete his answer', %(
  In order to avoid redundant answers
  As an authenticated user
  I'd like to be able to delete my answers
), js: true do
  given(:user) { create(:user) }
  given(:another_user) { create(:user) }
  given(:question) { create(:question, user:) }
  given!(:answer) { create(:answer, question:, user:) }
  given!(:another_answer) { create(:answer, question:, user: another_user) }

  describe 'Authenticated user' do
    background do
      sign_in(user)
      visit question_path(question)
    end

    scenario 'delete his answer' do
      accept_confirm do
        click_link('Delete', class: 'answer-delete-link')
      end

      expect(page).to have_no_content(answer.body)
    end

    scenario 'does not see delete button on someone else answer' do
      within "#answer-#{another_answer.id}" do
        expect(page).not_to have_link('Delete', class: 'answer-delete-link')
      end
    end
  end

  describe 'Guest' do
    scenario 'does not see delete button on any answer' do
      visit question_path(question)

      within('.answers') do
        expect(page).to have_no_link('Delete', class: 'answer-delete-link')
      end
    end
  end
end
