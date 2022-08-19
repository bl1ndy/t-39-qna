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

  scenario 'User add links when creates answer' do
    sign_in(user)
    visit question_path(question)

    fill_in 'Text', with: 'Test answer body'
    fill_in(id: 'answer_links_attributes_0_title', with: 'My gist')
    fill_in(id: 'answer_links_attributes_0_url', with: gist_url)
    click_button 'Post Your Answer'

    within '.answers' do
      expect(page).to have_link('My gist', href: gist_url)
    end
  end
end
