# frozen_string_literal: true

require 'rails_helper'

feature 'User can create a question', %(
  In order to ask community for help
  As an authenticated user
  I'd like to be able to ask questions
) do
  given(:user) { create(:user) }

  describe 'Authenticated user' do
    background do
      sign_in(user)

      visit questions_path
      click_on 'Ask Question'
    end

    scenario 'creates a question' do
      fill_in 'Title', with: 'Test Question title'
      fill_in 'Text', with: 'Test Question text'
      click_button 'Create'

      expect(page).to have_content('Your Question successfully created!')
      expect(page).to have_content('Test Question title')
      expect(page).to have_content('Test Question text')
    end

    scenario 'creates a question with errors' do
      click_button 'Create'

      expect(page).to have_content("Title can't be blank")
    end

    scenario 'creates a question with attached files' do
      fill_in 'Title', with: 'Test Question title'
      fill_in 'Text', with: 'Test Question text'
      attach_file 'Files', [Rails.root.join('spec/rails_helper.rb'), Rails.root.join('spec/spec_helper.rb')]
      click_button 'Create'

      expect(page).to have_link('rails_helper.rb')
      expect(page).to have_link('spec_helper.rb')
    end
  end

  scenario 'Guest tries to create a question' do
    visit questions_path
    click_on 'Ask Question'

    expect(page).to have_content('You need to sign in or sign up before continuing.')
  end
end
