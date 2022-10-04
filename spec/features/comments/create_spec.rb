# frozen_string_literal: true

require 'rails_helper'

feature 'User can add comments to question/answer', %(
  In order to give/take additional info for any post
  As an authenticated user
  I'd like to be able to add comments
), :js do
  given(:user) { create(:user) }
  given(:question) { create(:question, user:) }
  given!(:answer) { create(:answer, question:, user:) }

  describe 'Authenticated user' do
    background do
      sign_in(user)
      visit question_path(question)
    end

    scenario 'adds comment to question' do
      within '#question-comments' do
        fill_in(placeholder: 'text', with: 'Test question comment')
        click_button 'Add a comment'

        expect(page).to have_content('Test question comment')
      end
    end

    scenario 'adds comment to answer' do
      within "#answer-#{answer.id}-comments" do
        fill_in(placeholder: 'text', with: 'Test answer comment')
        click_button 'Add a comment'

        expect(page).to have_content('Test answer comment')
      end
    end

    scenario 'adds a comment with errors' do
      within '#question-comments' do
        click_button 'Add a comment'

        expect(page).to have_content("Body can't be blank")
      end

      within "#answer-#{answer.id}-comments" do
        click_button 'Add a comment'

        expect(page).to have_content("Body can't be blank")
      end
    end
  end

  describe 'Guest' do
    scenario 'does not see new comment form' do
      visit question_path(question)

      expect(page).to have_no_content('Add a comment')
    end
  end

  describe 'By channel' do
    # rubocop:disable RSpec/ExampleLength
    scenario 'Comments appears for another users after create' do
      Capybara.using_session('user') do
        sign_in(user)
        visit question_path(question)
      end

      Capybara.using_session('guest') do
        visit question_path(question)
      end

      Capybara.using_session('user') do
        within '#question-comments' do
          fill_in(placeholder: 'text', with: 'Test question comment')
          click_button 'Add a comment'
        end

        within "#answer-#{answer.id}-comments" do
          fill_in(placeholder: 'text', with: 'Test answer comment')
          click_button 'Add a comment'
        end
      end

      Capybara.using_session('guest') do
        expect(page).to have_content('Test question comment')
        expect(page).to have_content('Test answer comment')
      end
    end
    # rubocop:enable RSpec/ExampleLength
  end
end
