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

    answer.links.create(title: 'test link', url: 'http://example.com')
  end

  describe 'Authenticated user' do
    background do
      sign_in(user)
      visit question_path(question)
    end

    scenario 'edits his answer' do
      within '.answers' do
        click_link 'Edit'
        fill_in(id: 'answer_body', with: 'edited answer')
        click_button 'Save'

        expect(page).not_to have_content(answer.body)
        expect(page).to have_content('edited answer')
        expect(page).not_to have_selector('textarea')
      end
    end

    scenario 'edits his answer with attached files' do
      within '.answers' do
        click_link 'Edit'
        attach_file 'answer_files', [Rails.root.join('spec/rails_helper.rb'), Rails.root.join('spec/spec_helper.rb')]
        click_button 'Save'

        expect(page).to have_link('factory_bot.rb') # check that first attachment is not replaced by new files
        expect(page).to have_link('rails_helper.rb')
        expect(page).to have_link('spec_helper.rb')
      end
    end

    # rubocop:disable RSpec/ExampleLength
    scenario 'edits his answer with links' do
      within "#answer-#{answer.id}" do
        click_link 'Edit'
        click_link 'Add link'

        within(:xpath, "//div[@id='answer-links']/div[contains(@class, 'nested-fields')][2]") do
          fill_in(placeholder: 'title', with: 'test link 2')
          fill_in(placeholder: 'url', with: 'http://example2.com')
        end

        click_button 'Save'

        expect(page).to have_link('test link', href: 'http://example.com')
        expect(page).to have_link('test link 2', href: 'http://example2.com')
      end
    end
    # rubocop:enable RSpec/ExampleLength

    scenario 'deletes attached file' do
      within "#answer-#{answer.id} .answer-files" do
        click_link(class: 'btn-close')

        expect(page).to have_no_link('factory_bot.rb')
      end
    end

    scenario 'deletes link' do
      within "#answer-#{answer.id} .answer-links" do
        click_link(class: 'btn-close')

        expect(page).to have_no_link('test link')
      end
    end

    scenario 'edits his answer with errors' do
      click_link 'Edit'

      within '.answers' do
        fill_in(id: 'answer_body', with: '')
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
        expect(page).not_to have_link(class: 'btn-close')
      end
    end

    scenario 'does not see delete link on links in answer' do
      within "#answer-#{answer.id} .answer-links" do
        expect(page).not_to have_link(class: 'btn-close')
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
        expect(page).not_to have_link(class: 'btn-close')
      end
    end

    scenario 'does not see delete link on links in answer' do
      within "#answer-#{answer.id} .answer-links" do
        expect(page).not_to have_link(class: 'btn-close')
      end
    end
  end
end
