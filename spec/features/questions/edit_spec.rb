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

  background do
    question.files.attach(
      io: File.open(Rails.root.join('spec/support/factory_bot.rb')),
      filename: 'factory_bot.rb'
    )

    question.links.create(title: 'test link', url: 'http://example.com')
  end

  describe 'Authenticated user' do
    background do
      sign_in(user)
      visit question_path(question)
    end

    # rubocop:disable RSpec/ExampleLength, RSpec/MultipleExpectations
    scenario 'edits his question' do
      within '.question' do
        click_link 'Edit'
        fill_in(id: 'question_title', with: 'edited title')
        fill_in(id: 'question_body', with: 'edited text')
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
      within '.question' do
        click_link 'Edit'
        attach_file 'question_files', [Rails.root.join('spec/rails_helper.rb'), Rails.root.join('spec/spec_helper.rb')]
        click_button 'Save'

        expect(page).to have_link('factory_bot.rb') # check that first attachment is not replaced by new files
        expect(page).to have_link('rails_helper.rb')
        expect(page).to have_link('spec_helper.rb')
      end
    end

    # rubocop:disable RSpec/ExampleLength
    scenario 'edits his question with links' do
      within '.question' do
        click_link 'Edit'
        click_link 'Add link'

        within(:xpath, "//div[@id='question-links']/div[contains(@class, 'nested-fields')][2]") do
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
      within '.question-files' do
        click_link(class: 'btn-close')

        expect(page).to have_no_link('factory_bot.rb')
      end
    end

    scenario 'deletes link' do
      within '.question-links' do
        click_link(class: 'btn-close')

        expect(page).to have_no_link('test link')
      end
    end

    scenario 'edits his question with errors' do
      within '.question' do
        click_link 'Edit'
        fill_in(id: 'question_title', with: '')
        fill_in(id: 'question_body', with: '')
        click_button 'Save'

        expect(page).to have_content("Title can't be blank")
        expect(page).to have_content("Body can't be blank")
      end
    end
  end

  describe "Not question's author" do
    background do
      sign_in(another_user)
      visit question_path(question)
    end

    scenario 'does not see edit link on question' do
      within '.question' do
        expect(page).not_to have_link('Edit')
      end
    end

    scenario 'does not see delete link on files in someone else question' do
      within '.question-files' do
        expect(page).not_to have_link(class: 'btn-close')
      end
    end

    scenario 'does not see delete link on links in someone else question' do
      within '.question-links' do
        expect(page).not_to have_link(class: 'btn-close')
      end
    end
  end

  describe 'Guest' do
    background { visit question_path(question) }

    scenario 'does not see edit link in question' do
      within '.question' do
        expect(page).not_to have_link('Edit')
      end
    end

    scenario 'does not see delete link on files in question' do
      within '.question-files' do
        expect(page).not_to have_link(class: 'btn-close')
      end
    end

    scenario 'does not see delete link on links in question' do
      within '.question-links' do
        expect(page).not_to have_link(class: 'btn-close')
      end
    end
  end
end
