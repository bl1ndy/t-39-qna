# frozen_string_literal: true

require 'rails_helper'

feature 'User can add reward for best answer on question creating', %(
  In order to stimulate other users to answer my question
  As an authenticated user
  I'd like to be able to add reward for best answer when I creating question
) do
  given(:user) { create(:user) }
  given(:question) { create(:question, user:) }

  background do
    sign_in(user)

    visit questions_path
    click_on 'Ask Question'
  end

  scenario 'User adds reward to question' do
    fill_in 'Title', with: 'Test Question title'
    fill_in 'Text', with: 'Test Question text'

    within '#question-reward' do
      fill_in(placeholder: 'title', with: 'test reward')
      fill_in(placeholder: 'image url', with: '/assets/default_badge.png')
    end

    click_button 'Create'

    expect(page).to have_content('Author offers a Reward for Best Answer!')
  end
end
