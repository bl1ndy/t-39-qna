# frozen_string_literal: true

require 'rails_helper'

feature 'User can add links to question', %(
  In order to give additional info for my question
  As an question's author
  I'd like to be able to add links
), js: true do
  given(:user) { create(:user) }
  given(:gist_url) { 'https://gist.github.com/bl1ndy/b5d79c9d5e7a312edd5fb27c67f69b68' }
  given(:another_url) { 'https://example.com' }

  background do
    sign_in(user)
    visit new_question_path
  end

  # rubocop:disable RSpec/ExampleLength
  scenario 'User add links when creates question' do
    fill_in 'Title', with: 'Test question title'
    fill_in 'Text', with: 'Test question body'

    within '#links' do
      fill_in(placeholder: 'title', with: 'My gist')
      fill_in(placeholder: 'url', with: gist_url)
    end

    click_link 'Add link'

    within '#links .nested-fields:nth-child(2)' do
      fill_in(placeholder: 'title', with: 'Another link')
      fill_in(placeholder: 'url', with: another_url)
    end

    click_button 'Create'

    expect(page).to have_link('My gist', href: gist_url)
    expect(page).to have_link('Another link', href: another_url)
  end
  # rubocop:enable RSpec/ExampleLength
end
