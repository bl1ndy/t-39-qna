# frozen_string_literal: true

require 'rails_helper'

feature 'User can get reward for best answer', %(
  In order to get satisfaction of helping other users
  As an authenticated user
  I'd like to be able to get reward when my answer is the best answer for question
), js: true do
  given(:user) { create(:user) }
  given(:another_user) { create(:user) }
  given(:question) { create(:question, user:) }
  given!(:answer) { create(:answer, question:, user:) }
  given!(:another_answer) { create(:answer, question:, user: another_user) }

  background do
    question.create_reward(title: 'Test Reward', image_url: '/assets/default_badge.png')

    sign_in(user)

    visit question_path(question)

    within "#answer-#{answer.id}" do
      click_button 'Best'
    end
  end

  scenario 'User sees his rewards on achievements page' do
    visit achievements_path

    expect(page).to have_xpath('//img[@alt="Test Reward"]')
    expect(page).to have_content('Test Reward')
    expect(page).to have_link(question.title, href: question_path(question))
  end

  scenario 'User do not see reward if another answer was marked as best' do
    within "#answer-#{another_answer.id}" do
      click_button 'Best'
    end

    visit achievements_path

    expect(page).to have_no_xpath('//img[@alt="Test Reward"]')
    expect(page).to have_no_content('Test Reward')
    expect(page).to have_no_link(question.title, href: question_path(question))
  end
end
