# frozen_string_literal: true

require 'rails_helper'

feature 'User can edit his answer', %(
  In order to correct mistakes
  As an answer's author
  I'd like to be able to edit my answer
), js: true do
  given(:user) { create(:user) }
  given(:another_user) { create(:user) }
  given(:question) { create(:question) }
  given!(:answer) { create(:answer, question:, user:) }
  given!(:another_answer) { create(:answer, question:, user: another_user) }

  describe 'Authenticated user' do
    background do
      sign_in(user)
      visit question_path(question)
    end

    scenario 'edits his answer' do
      within '.answers' do
        click_link 'Edit'
        fill_in 'Text', with: 'edited answer'
        click_button 'Save'

        expect(page).not_to have_content(answer.body)
        expect(page).to have_content('edited answer')
        expect(page).not_to have_selector('textarea')
      end
    end

    scenario 'edits his answer with attached files' do
      within '.answers' do
        click_link 'Edit'
        attach_file 'Files', [Rails.root.join('spec/rails_helper.rb'), Rails.root.join('spec/spec_helper.rb')]
        click_button 'Save'

        expect(page).to have_link('rails_helper.rb')
        expect(page).to have_link('spec_helper.rb')
      end
    end

    # rubocop:disable RSpec/ExampleLength
    scenario 'adds new file to existing one instead of replacing it' do
      within '.answers' do
        click_link 'Edit'
        attach_file 'Files', [Rails.root.join('spec/rails_helper.rb')]
        click_button 'Save'
        click_link 'Edit'
        attach_file 'Files', [Rails.root.join('spec/spec_helper.rb')]
        click_button 'Save'

        sleep 0.1
        expect(page).to have_link('rails_helper.rb')
        expect(page).to have_link('spec_helper.rb')
      end
    end
    # rubocop:enable RSpec/ExampleLength

    scenario 'edits his answer with errors' do
      click_link 'Edit'

      within '.answers' do
        fill_in 'Text', with: ''
        click_button 'Save'

        expect(page).to have_content("Body can't be blank")
      end
    end

    scenario 'does not see edit link on someone else answer' do
      within "#answer-#{another_answer.id}" do
        expect(page).not_to have_link('Edit')
      end
    end
  end

  describe 'Guest' do
    scenario 'does not see edit link on any answer' do
      visit question_path(question)

      within '.answers' do
        expect(page).not_to have_link('Edit')
      end
    end
  end
end
