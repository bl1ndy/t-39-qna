# frozen_string_literal: true

require 'rails_helper'

feature 'User can edit his question', %(
  In order to correct mistakes and information
  As an question's author
  I'd like to be able to edit my question
), js: true do
  given(:user) { create(:user) }
  given(:another_user) { create(:user) }
  given(:question) { create(:question, user:) }
  given(:another_question) { create(:question, user: another_user) }

  describe 'Authenticated user' do
    background do
      sign_in(user)
    end

    # rubocop:disable RSpec/ExampleLength, RSpec/MultipleExpectations
    scenario 'edits his question' do
      visit question_path(question)

      within '.question' do
        click_link 'Edit'
        fill_in 'Title', with: 'edited title'
        fill_in 'Text', with: 'edited text'
        click_button 'Save'

        expect(page).not_to have_content(question.title)
        expect(page).not_to have_content(question.body)
        expect(page).to have_content('edited title')
        expect(page).to have_content('edited text')
        expect(page).not_to have_selector('textarea')
      end
    end
    # rubocop:enable RSpec/ExampleLength, RSpec/MultipleExpectations

    scenario 'edits his question with attached files' do
      visit question_path(question)

      within '.question' do
        click_link 'Edit'
        attach_file 'Files', [Rails.root.join('spec/rails_helper.rb'), Rails.root.join('spec/spec_helper.rb')]
        click_button 'Save'

        expect(page).to have_link('rails_helper.rb')
        expect(page).to have_link('spec_helper.rb')
      end
    end

    # rubocop:disable RSpec/ExampleLength
    scenario 'adds new file to existing one instead of replacing it' do
      visit question_path(question)

      within '.question' do
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

    scenario 'edits his question with errors' do
      visit question_path(question)

      within '.question' do
        click_link 'Edit'
        fill_in 'Title', with: ''
        fill_in 'Text', with: ''
        click_button 'Save'

        expect(page).to have_content("Title can't be blank")
        expect(page).to have_content("Body can't be blank")
      end
    end

    scenario 'does not see edit link on someone else question' do
      visit question_path(another_question)

      within '.question' do
        expect(page).not_to have_link('Edit')
      end
    end
  end

  describe 'Guest' do
    scenario 'does not see edit link on any question' do
      visit question_path(question)

      within '.question' do
        expect(page).not_to have_link('Edit')
      end

      visit question_path(another_question)

      within '.question' do
        expect(page).not_to have_link('Edit')
      end
    end
  end
end
