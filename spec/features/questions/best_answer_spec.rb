# frozen_string_literal: true

require 'rails_helper'

feature 'User can mark preferred answer as the best for his question', %(
  In order to give info about the most helpful answer
  As an question's author
  I'd like to be able to mark an answer as the best
), js: true do
  given(:user) { create(:user) }
  given(:another_user) { create(:user) }
  given(:question) { create(:question, user:) }
  given!(:answer) { create(:answer, question:, user:) }

  describe "Question's author" do
    scenario 'marks an answer as the best' do
      sign_in(user)
      visit question_path(question)

      within "#answer-#{answer.id}" do
        click_button 'Best'

        expect(page).to have_content('Best answer:')
      end
    end
  end

  describe "Not question's author" do
    scenario 'does not see Best button on any answer' do
      sign_in(another_user)
      visit question_path(question)

      within '.answers' do
        expect(page).to have_no_button('Best')
      end
    end
  end
end
