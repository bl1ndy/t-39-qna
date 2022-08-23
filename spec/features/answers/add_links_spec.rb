# frozen_string_literal: true

require 'rails_helper'

feature 'User can add links to answer', %(
  In order to give additional info for my answer
  As an answer's author
  I'd like to be able to add links
), js: true do
  given(:user) { create(:user) }
  given(:question) { create(:question, user:) }
  given(:gist_url) { 'https://gist.github.com/bl1ndy/b5d79c9d5e7a312edd5fb27c67f69b68' }
  given(:another_url) { 'https://gist.github.com' }

  background do
    sign_in(user)
    visit question_path(question)
  end

  # rubocop:disable RSpec/ExampleLength
  scenario 'User add links when creates answer' do
    fill_in 'Text', with: 'Test answer body'

    within '#answer-links' do
      fill_in(placeholder: 'title', with: 'My gist')
      fill_in(placeholder: 'url', with: gist_url)
    end

    click_link 'Add link'

    within(:xpath, "//div[@id='answer-links']/div[contains(@class, 'nested-fields')][2]") do
      fill_in(placeholder: 'title', with: 'Another link')
      fill_in(placeholder: 'url', with: another_url)
    end

    click_button 'Post Your Answer'

    within '.answers' do
      expect(page).to have_link('My gist', href: gist_url)
      expect(page).to have_link('Another link', href: another_url)
    end
  end
  # rubocop:enable RSpec/ExampleLength
end
