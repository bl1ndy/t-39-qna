# frozen_string_literal: true

require 'rails_helper'

feature 'User can add links to question', %(
  In order to give additional info for my question
  As an question's author
  I'd like to be able to add links
), js: true do
  given(:user) { create(:user) }
  given(:gist_url) { 'https://gist.github.com/bl1ndy/b5d79c9d5e7a312edd5fb27c67f69b68' }

  scenario 'User add links when creates question' do
    sign_in(user)
    visit new_question_path

    fill_in 'Title', with: 'Test question title'
    fill_in 'Text', with: 'Test question body'
    fill_in(id: 'question_links_attributes_0_title', with: 'My gist')
    fill_in(id: 'question_links_attributes_0_url', with: gist_url)
    click_button 'Create'

    expect(page).to have_link('My gist', href: gist_url)
  end
end
