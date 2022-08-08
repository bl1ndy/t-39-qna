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

  background do
    answer.files.attach(
      io: File.open(Rails.root.join('spec/support/factory_bot.rb')),
      filename: 'factory_bot.rb'
    )
  end

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

        expect(page).to have_link('factory_bot.rb') # check that first attachment is not replaced by new files
        expect(page).to have_link('rails_helper.rb')
        expect(page).to have_link('spec_helper.rb')
      end
    end

    scenario 'deletes attached file' do
      within "#answer-#{answer.id} .answer-files" do
        click_link 'Delete'

        expect(page).to have_no_link('factory_bot.rb')
      end
    end

    scenario 'edits his answer with errors' do
      click_link 'Edit'

      within '.answers' do
        fill_in 'Text', with: ''
        click_button 'Save'

        expect(page).to have_content("Body can't be blank")
      end
    end
  end

  describe "Not answer's author" do
    background do
      sign_in(another_user)
      visit question_path(question)
    end

    scenario 'does not see edit link on answer' do
      within "#answer-#{answer.id}" do
        expect(page).not_to have_link('Edit')
      end
    end

    scenario 'does not see delete link on files in answer' do
      within "#answer-#{answer.id} .answer-files" do
        expect(page).not_to have_link('Delete')
      end
    end
  end

  describe 'Guest' do
    background { visit question_path(question) }

    scenario 'does not see edit link in answer' do
      within '.answers' do
        expect(page).not_to have_link('Edit')
      end
    end

    scenario 'does not see delete link on files in answer' do
      within "#answer-#{answer.id} .answer-files" do
        expect(page).not_to have_link('Delete')
      end
    end
  end
end
