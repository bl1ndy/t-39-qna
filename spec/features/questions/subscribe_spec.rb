# frozen_string_literal: true

require 'rails_helper'

feature 'User can subscribe and unsubscribe on/from question', %(
  In order to get/remove notifications about new answers for question
  As an authenticated user
  I'd like to be able to subscribe and unsubscribe on/from question
) do
  given(:user) { create(:user) }
  given(:question) { create(:question) }

  describe 'Authenticated user' do
    background { sign_in(user) }

    scenario 'subscribes on his question automatically after create' do
      visit questions_path
      click_on 'Ask Question'
      fill_in 'Title', with: 'Test Question title'
      fill_in 'Text', with: 'Test Question text'
      click_button 'Create'

      expect(page).to have_button(class: 'unsubscribe-button')
    end

    scenario 'subscribes on question', :js do
      visit question_path(question)
      click_button(class: 'subscribe-button')

      expect(page).to have_button(class: 'unsubscribe-button')
      expect(page).to have_no_button(class: 'subscribe-button')
    end

    scenario 'unsubscribes from question', :js do
      question.subscriptions.create(user:)

      visit question_path(question)
      click_button(class: 'unsubscribe-button')

      expect(page).to have_button(class: 'subscribe-button')
      expect(page).to have_no_button(class: 'unsubscribe-button')
    end
  end

  scenario 'Guest does not see subscription buttons' do
    visit question_path(question)

    expect(page).to have_no_button(class: 'subscribe-button')
    expect(page).to have_no_button(class: 'unsubscribe-button')
  end
end
